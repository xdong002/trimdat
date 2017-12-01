module DocumentsHelper


  def sort_by_first_value_number()
    #sort by first value, if number is the first value
    #converting to integers and comparing two items in the callback (sorting on them)
    array_of_lines! { |a, b| a[0].to_i <=> b[0].to_i }
    #modify the existing array
    array_of_lines.uniq!(&:first)
    array_of_lines.each { |line| p line }
  end

  def fix_file(params={}, content_in)
    @sort_by_input = params.delete(:sort_by)
    @rmv_duplicate_input = params.delete(:rmv_duplicate)
    @word_occurrence_input = params.delete(:word_occurrence)
    @customize_input = params.delete(:customize)
    @request_hash = {"sort_by" => @sort_by_input, "rmv_duplicate" => @rmv_duplicate_input, "word_occurrence" => @word_occurrence_input, "customize" => @customize_input}
    @content_in = content_in
    @content_array = content_to_hash_array(@content_in)
    puts "@content_array = #{@content_array}"
    puts "@sort_by = '#{@sort_by_input}' and is it truthy? #{@sort_by_input ? "true" : "false"} and class is: #{@sort_by_input.class}"
    puts "@customize = '#{@customize_input}' and is it truthy? #{@customize_input ? "true" : "false"} and class is: #{@customize_input.class}"

    fix_all_requests @request_hash
  end

  def content_to_hash_array content_in
    str_array = content_in.split(/\r\n|\t|\n|\r/)
    puts "str_array: #{str_array}"
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
    hash_in.each {|key, value| self.public_send(key) if self.respond_to? key}
    puts "here's the new hash_in: #{hash_in}"
    puts "content_in: #{@content_in}"
  end

  def sort_by
    puts "sort_by method inside Helper called!!!!!!!"
  end


  def rmv_duplicate
    puts "rmv method called"
  end

  def word_occurrence
    puts "word_occurrence method called"
  end

  def customize
    puts "customize method called"
  end

  # array_of_lines = []

  # import the file as an array
  # File.open("./FL_insurance_sample.csv", "r") do |f|
  #   f.each_line do |line|
  #   array_of_lines += line.split(/\t|\n|\r|\r\n/)
  # end

  # def sort_by_first_value_number()
  # #sort by first value, if number is the first value
  # #converting to integers and comparing two items in the callback (sorting on them)
  # array_of_lines! { |a, b| a[0].to_i <=> b[0].to_i }
  # #modify the existing array
  # array_of_lines.uniq!(&:first)
  # array_of_lines.each { |line| p line }
  # end

end
