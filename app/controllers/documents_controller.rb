class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy, :download_origin, :download_fixed, :fix, :get_fixed, :share_doc]

  # Send original file to user
  def download_origin
    send_data(@document.original_file, type: @document.data_type, filename: @document.name)
  end

  # Send fixed file to user
  def download_fixed
    send_data(@document.fixed_file, type: @document.data_type, filename: @document.name)
  end

  #Delete user from sharing list if current user is the file owner
  #Remove current user from the sharing list if current user isn't file owner
  def unshare
    puts params
    @document = Document.find(params[:document_id])
    @user_to_unshare = User.find(params[:unshare_id])
    puts @document.users
    unshare_relation = @document.users.find(@user_to_unshare.id)
    @document.users.delete(unshare_relation)
    if params[:redirect_target] == "user_show"
      flash[:notice] = "You stopped unfollowed file #{@document.name}"
      redirect_to user_path(current_user.id)
    else
      flash[:notice] = "Deleted #{@user_to_unshare.user_name} from sharing list"
      redirect_to document_show_path(@document.id)
    end
  end

  #Give other users access to this file by user_name
  def share_doc
    if @user_to_share = User.find_by(share_doc_params)
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
        if params[:redirect_target] == "user_show"
          redirect_to user_path(current_user.id)
        else
          redirect_to document_show_path(@document.id)
        end
      end
    else
      flash[:notice] = "Can not find user name: #{share_doc_params[:user_name]}"
      if params[:redirect_target] == "user_show"
        redirect_to user_path(current_user.id)
      else
        redirect_to document_show_path(@document.id)
      end
    end
  end

  #return fixed file content in json format
  def get_fixed
    respond_to do |format|
      format.json {render :json => {:fixed => @document.fixed_file}}
    end
  end

  #render ocurrent file detail
  def show
    @user = current_user
  end

  #upload file
  def create
    @document = Document.new(document_params)
    @document.owner_id = current_user.id
    @document.owner_name = current_user.user_name
    if @document.original_file == "bad data_type"
      flash[:notice] = "File error! Please make sure you upload a txt/csv file encoded in UTF-8 or you don't upload an empty file"
      redirect_to user_path(current_user)
    elsif current_user.documents.push @document
      flash[:notice] = "#{@document.name} is uploaded!"
      redirect_to user_path(current_user)
    else
      puts "OH NOOOOOOOO!!!"
      flash[:error] = "Something went wrong :("
      redirect_to user_path(current_user)
    end
  end

  #get fixfile request. triggers methods in document_helper
  def fix
    fix_file(document_params, @document)
  end

  def update
    #**Future goal: let user edit original file online.
    #**  NOT ROUTED YET!! **
  end

  # remove selected file
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
