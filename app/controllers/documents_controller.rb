class DocumentsController < ApplicationController
#hi Masha this is Sherwin. if you see this, it means the master repo is fixed
  before_action :set_document, only: [:show, :edit, :update, :destroy, :download_origin, :download_fixed, :fix]

  # GET /documents
  # def index
  #   @documents = Document.all
  # end

  def download_origin
    send_data(@document.original_file, type: @document.data_type, filename: @document.name)
  end

  def download_fixed
    send_data(@document.fixed_file, type: @document.data_type, filename: @document.name)
  end

  # GET /documents/1
  def show

  end

  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  def create
    @document = Document.new(document_params)
    if @document.original_file == ""
      flash[:notice] = "File error! Please make sure you upload a txt/csv file encoded in UTF-8"
      redirect_to user_path(current_user)
    elsif current_user.documents.push @document
      flash[:notice] = "#{@document.name} is uploaded!"
      redirect_to user_path(current_user)
    else
      puts "OH NOOOOOOOO!!!"
    end
  end

  def show
  end

  def fix
    puts "yo! fix called:)"
    fix_file(document_params, @document)
  end

  def update
    puts "yo! update called:)"
    # if @document.update(:original_file => params[:new_content])
    #   redirect_to document_path(@document)
    # else
    #   puts "OH NOOOOOOOO!!!"
    # end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    flash[:notice] = "#{@document.name} has been deleted"
    redirect_to user_path(current_user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:file, :sort_by, :rmv_duplicate, :word_occurrence, :customize)
    end
end
