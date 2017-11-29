class User < ActiveRecord::Base
  has_secure_password
  has_many :document_librarys, dependent: :destroy
  has_many :documents, through: :document_librarys

  def self.confirm(params)
<<<<<<< HEAD
    @user = User.find_by({user_name: params[:user_name]})
=======
    @user = User.find_by({:user_name => params[:user_name]})
>>>>>>> 350ba9646002d561f807d745cb72f2e0ba6e1923
    @user ? @user.authenticate(params[:password]) : false
  end
end
