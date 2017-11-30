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

end
