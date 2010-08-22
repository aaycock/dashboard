class AdminController < ApplicationController


   # GET /admin/my_account
  def my_account
    @user = User.find(session[:user_id])
  end

  def login
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        session[:account_id] = user.account_id
        session[:user_first_name] = user.first_name
        session[:user_last_name] = user.last_name
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :action => "index"})
        #redirect_to(:action => "index")
      else
        flash.now[:notice] = "Invalid username/password"
      end
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_id] = nil
    session[:user_id] = nil
    redirect_to( :action => "login")
  end

  def index
  end

end
