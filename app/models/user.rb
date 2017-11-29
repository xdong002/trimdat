class User < ActiveRecord::Base
  has_secure_password
  has_many :document_librarys, dependent: :destroy
  has_many :documents, through: :document_librarys

  def self.confirm(params)
    @user = User.find_by({user_name: params[:user_name]})
    @user ? @user.authenticate(params[:password]) : false
  end
end
