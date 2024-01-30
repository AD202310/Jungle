class SessionsController < ApplicationController
  
  def new
  end

  def create
    @user = User.find_by_email(params[:email])
  
    if @user
      if @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect_to '/'
      else
        # Wrong password
        flash.now.alert = 'Invalid email or password'
        render 'new'
      end
    else
      # No user found with that email
      flash.now.alert = 'Email not found'
      render 'new'
    end
  end
  
end