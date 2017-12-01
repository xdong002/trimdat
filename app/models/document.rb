class Document < ApplicationRecord
  has_many :document_librarys, dependent: :destroy
  has_many :users, through: :document_librarys
	validate :file_size_under_one_mb, :on => :create
	# attr_accessor :word_occurrence

	def initialize(params = {})
	  # File is now an instance variable so it can be
	  # accessed in the validation.
	  @file = params.delete(:file)
	  super
	  if @file
	    self.name = sanitize_filename(@file.original_filename)
	    self.data_type = @file.content_type
	    if self.data_type == "text/csv" then puts "got text/csv" end
	    if self.data_type == "text/plain" then puts "got text/plain" end
	    if self.data_type != "text/csv" && self.data_type != "text/plain"
	    	self.original_file = ""
	    	return
	    end

	    begin  # "try" block
		    puts 'I am before the raise.'
		    self.original_file = @file.read.encode('utf-8', :invalid => :replace, :undef => :replace)
		    puts "OF: #{self.original_file}"
		    # Encoding::UndefinedConversionError ("\xAE" from ASCII-8BIT to UTF-8):
		    puts 'I am after the raise.'  # won't be executed
			rescue => e#Exception
		    self.original_file = ""
		    self.original_file = @file.read.force_encoding('iso-8859-1').encode('utf-8')
				logger.error e.message
		    # puts "I refuse to fail or be stopped!"
		  end

			# self.original_file = f_two.read.force_encoding('Windows-1252').encode('UTF-8')
	    self.content_status = "Pending"
	  end
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
