class Document < ApplicationRecord
  has_many :document_librarys, dependent: :destroy
  has_many :users, through: :document_librarys
	validate :file_size_under_one_mb, :on => :create

	def initialize(params = {})
	  # File is now an instance variable so it can be
	  # accessed in the validation.
	  @file = params.delete(:file)
	  super
	  if @file
	    self.name = sanitize_filename(@file.original_filename)
	    self.data_type = @file.content_type
	    self.original_file = @file.read
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
