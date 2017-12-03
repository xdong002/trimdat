module DocumentsHelper

  def fix_file(params={}, document_in)
    @document = document_in
    @document.update(:content_status => "done")
    content_in = document_in.original_file
    @sort_by_input = params.delete(:sort_by)
    @rmv_duplicate_input = params.delete(:rmv_duplicate)
    @word_occurrence_input = params.delete(:word_occurrence)
    @customize_input = params.delete(:customize)
    @request_hash = {"sort_by" => @sort_by_input, "rmv_duplicate" => @rmv_duplicate_input, "word_occurrence" => @word_occurrence_input, "customize" => @customize_input}
    @content_in = content_in
    @content_array = content_to_hash_array(@content_in)
    @frequency = []
    @content_out = ""
    puts "@content_array = #{@content_array}"
    puts "@sort_by = '#{@sort_by_input}' and is it truthy? #{@sort_by_input ? "true" : "false"} and class is: #{@sort_by_input.class}"
    puts "@customize = '#{@customize_input}' and is it truthy? #{@customize_input ? "true" : "false"} and class is: #{@customize_input.class}"

    fix_all_requests @request_hash
  end

  def get_header_array content_in
    str_array = content_in.split(/\r\n|\t|\n|\r/)
    str_array[0].split(/\s*,\s*/)
  end

  def content_to_hash_array content_in
    str_array = content_in.split(/\r\n|\t|\n|\r/)
    header_array = str_array[0].split(/\s*,\s*/)
    header_hash = {}
    header_array.each do |header|
      header_hash[:"#{header}"] = header
    end
    hash_array = [header_hash]
    str_array[1..-1].each do |data_row|
      data_array = data_row.split(/\s*,\s*/)
      new_data_hash = {}
      data_array.each_with_index do |data, j|
        header_name = header_array[j]
        new_data_hash[:"#{header_name}"] = data
      end
      hash_array << new_data_hash
    end
    hash_array
  end

  def fix_all_requests hash_in
    hash_in.delete_if {|key, value| !value}
    puts "here's the new hash_in: #{hash_in}"
    hash_in.each {|key, value| self.public_send(key) if self.respond_to? key}
    if @document.data_type == "text/csv"
      content_array_to_string_for_csv
    elsif @document.data_type == "text/plain" ||  @document.data_type == "application/vnd.ms-excel"
      content_array_to_string_for_txt
    end
    @document.update(:fixed_file => @content_out)
  end

  def content_array_to_string_for_csv
    header_array = get_header_array(@content_in)
    output_str = ""
    @content_array.each do |r|
      row_content = ""
      header_array.each do |c|
        row_content += "#{r[:"#{c}"]}, "
      end
      row_content.gsub!(/\, $/, "")
      row_content += "\r\n"
      output_str += row_content
    end
    if @frequency != []
      @frequency.each do |pair|
        output_str += "#{pair[0]}, #{pair[1]}\r\n"
      end
    end
    @content_out = output_str
  end

  def content_array_to_string_for_txt
    # @content_array
    output_str = ""
    output_str += @content_in
    if @frequency != []
      @frequency.each do |pair|
        output_str += "#{pair[0]}: #{pair[1]}\r\n"
      end
    end
    @content_out = output_str
  end

  def sort_by
    puts "sort_by method inside Helper called!!!!!!!"
    header_array = get_header_array(@content_in)
    if !header_array.include? @sort_by_input
      puts "doesn't include that headerrrrrr header: #{header_array}"
      puts "@sort_by_input: #{@sort_by_input}, class: #{@sort_by_input.class}"
      return
    end
    header_hash = @content_array[0]
    @content_array = @content_array[1..-1].sort_by { |k| k[:"#{@sort_by_input}"] }
    @content_array.unshift header_hash
    puts "sorted: #{@content_array}"
  end


  def rmv_duplicate
    puts "rmv method called"
    puts "rmv_duplicate array: #{@content_array.uniq}"
    @content_array = @content_array.uniq
  end

  def word_occurrence
    puts "word_occurrence method called"
    words = @content_in.split(/[^A-Za-z0-9]/)
    frequency = Hash.new(0)
    words.each do |word|
      word = word.gsub(/[^A-Za-z]/, "")
      if word != "" then frequency[word.downcase] += 1 end
    end
    puts "class: #{frequency.class}" 
    puts "frequency_before: #{frequency}"
    frequency = frequency.sort{ |l, r| l[1]<=>r[1] }.reverse
    puts "frequency: #{frequency}"
    @frequency = frequency
  end

  def customize
    puts "customize method called"
    @document.update(:content_status => "Request: #{@customize_input}")
  end

end
