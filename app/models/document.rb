class Document < ApplicationRecord
  has_many :document_librarys, dependent: :destroy
  has_many :users, through: :document_librarys
	validate :file_size_under_one_mb, :on => :create
	# attr_accessor :word_count

	def initialize(params = {})
	  # File is now an instance variable so it can be
	  # accessed in the validation.
	  @file = params.delete(:file)
	  @sort_by_input = params.delete(:sort_by)
	  @rmv_duplicate_input = params.delete(:rmv_duplicate)
	  @word_count_input = params.delete(:word_count)
	  @customize_input = params.delete(:customize)
	  @request_hash = {"sort_by" => @sort_by_input, "rmv_duplicate" => @rmv_duplicate_input, "word_count" => @word_count_input, "customize" => @customize_input}

	  puts "@sort_by = '#{@sort_by}' and is it truthy? #{@sort_by ? "true" : "false"} and class is: #{@sort_by.class}"
	  puts "@customize = '#{@customize}' and is it truthy? #{@customize ? "true" : "false"} and class is: #{@customize.class}"

	  fix_the_file(@request_hash)
	  super
	  if @file
	    self.name = sanitize_filename(@file.original_filename)
	    self.data_type = @file.content_type
	    self.original_file = @file.read.force_encoding('Windows-1252').encode('UTF-8')
	    self.content_status = "Pending"
	  end
	end

	def fix_the_file hash_in
		hash_in.delete_if {|key, value| !value}
		hash_in.each {|key, value| self.public_send(key) if self.respond_to? key}
		puts "here's the new hash_in: #{hash_in}"
	end

	def sort_by
		puts "sort_by method called"
	end

	def rmv_duplicate
		puts "rmv method called"
	end

	def word_count
		puts "word_count method called"
	end

	def customize
		puts "customize method called"
	end

	NUM_BYTES_IN_MEGABYTE = 1048576
	def file_size_under_one_mb
	  if (@file.size.to_f / NUM_BYTES_IN_MEGABYTE) > 1
	    errors.add(:file, 'Document size cannot be over one megabyte.')
	  end
	end

	private
	def sanitize_filename(filename)
	# Get only the filename, not the whole path (for IE)
	# Thanks to this article I just found for the tip: http://mattberther.com/2007/10/19/uploading-files-to-a-database-using-rails
	return File.basename(filename)
	end
end
