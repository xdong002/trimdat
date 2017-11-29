class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  # def index
  #   @documents = Document.all
  # end

  # GET /documents/1
  def show
    send_data(@document.original_file, type: @document.data_type, filename: @document.name)
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  def create
    @document = Document.new(document_params)
    if current_user.documents.push @document
      redirect_to user_url(current_user)
    else
      puts "OH NOOOOOOOO!!!"
    end
  end

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
    respond_to do |format|
      format.html { redirect_to user_url(current_user), notice: 'Document was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:file)
    end
end
