class DocumentsController < ApplicationController
#hi Masha this is Sherwin. if you see this, it means the master repo is fixed
  before_action :set_document, only: [:show, :edit, :update, :destroy, :download_origin, :download_fixed, :fix, :get_fixed, :share_doc]

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

  def unshare
    puts params
    @document = Document.find(params[:document_id])
    @user_to_unshare = User.find(params[:unshare_id])
    puts @document.users
    unshare_relation = @document.users.find(@user_to_unshare.id)
    flash[:notice] = "Deleted #{@user_to_unshare.user_name} from sharing list"
    @document.users.delete(unshare_relation)
    redirect_to document_show_path(@document.id)
  end

  def share_doc
    puts "yooo: #{share_doc_params[:user_name]}"
    puts "did I get document id? #{params[:id]}"
    if @user_to_share = User.find_by(share_doc_params)
      puts @user_to_share
      if @document.users.where(user_name: @user_to_share[:user_name]).exists?
        flash[:notice] = "#{@user_to_share[:user_name]} is already on the list"
        if params[:redirect_target] == "user_show"
          redirect_to user_path(current_user.id)
        else
          redirect_to document_show_path(@document.id)
        end
      else
        @document.users << @user_to_share
        flash[:notice] = "#{@user_to_share[:user_name]} is now on the list"
        puts params
        if params[:redirect_target] == "user_show"
          redirect_to user_path(current_user.id)
        else
          redirect_to document_show_path(@document.id)
        end
      end
    else
      puts "user not found"
      flash[:notice] = "Can not find user name: #{share_doc_params[:user_name]}"
      if params[:redirect_target] == "user_show"
        redirect_to user_path(current_user.id)
      else
        redirect_to document_show_path(@document.id)
      end
    end
  end

  def get_fixed
    puts "get_fixed method called"
    respond_to do |format|
      format.json {render :json => {:fixed => @document.fixed_file}}
    end
    # response
  end

  # GET /documents/1
  def show
    @user = current_user
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

    def share_doc_params
      params.require(:document).permit(:user_name)
    end
end
