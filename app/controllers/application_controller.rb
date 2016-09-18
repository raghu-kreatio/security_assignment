class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :setuser, except: [:login, :verify_login]

  def setuser
    @user = User.find_by_id(session[:user_id])
    if @user
      @role = @user.role
    else
      redirect_to :root
    end
  end
end
