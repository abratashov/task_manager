class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_to :controller => 'tasks', :action => 'index', :notice => "Logged in!"
    else
      flash.now.alert = "Email or password was invalid."
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end
end
