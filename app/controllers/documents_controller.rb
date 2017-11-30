class DocumentsController < ApplicationController

  before_action :set_document, only: [:show, :edit, :update, :destroy, :download_origin]

  # GET /documents
  # def index
  #   @documents = Document.all
  # end

  def download_origin
    send_data(@document.original_file, type: @document.data_type, filename: @document.name)
  end

  # GET /documents/1
  def show

  end

  def new
  #import the file as an array
  # File.open("./FL_insurance_sample.csv", "r") do |f|
  #   f.each_line do |line|
  #   array_of_lines += line.split(/\t|\n|\r|\r\n/)
  # end
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  def create
    @document = Document.new(document_params)
    if current_user.documents.push @document
      redirect_to user_path(current_user)
    else
      puts "OH NOOOOOOOO!!!"
    end
  end

  def show
  end

  # def sort_by_first_value_number()
  # #sort by first value, if number is the first value
  # #converting to integers and comparing two items in the callback (sorting on them)
  # array_of_lines! { |a, b| a[0].to_i <=> b[0].to_i }
  # #modify the existing array
  # array_of_lines.uniq!(&:first)
  # array_of_lines.each { |line| p line }
  # end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
    
  def update
    # new_contents = erase_blank(@document.file_contents.to_s)
    # puts "document.file_contents is : #{@document.file_contents}"
    # puts "document.file_contents.to_s is : #{@document.file_contents.to_s}"
    # puts "new_contents is : #{new_contents}"
    # if @document.update(:file_contents => new_contents)
    #   redirect_to document_path(@document)
    # else
    #   puts "OH NOOOOOOOO!!!"
    # end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    redirect_to user_path(current_user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:file, :sort_by, :rmv_duplicate, :word_count, :customize)
    end
end
