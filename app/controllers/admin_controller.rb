class AdminController < ApplicationController

  

  # GET /admin/my_account
  def my_info
    @user = User.find(session[:user].id)
  end

  # GET /admin/my_account
  def my_account
    @account = Account.find(session[:account].id)
    @products = Chargify::Product.find(:all)
  end


  def login
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user] = user
        session[:account] = Account.find(user.account_id)
        session[:user_id] = user.id
        session[:account_id] = user.account_id
        session[:user_first_name] = user.first_name
        session[:user_last_name] = user.last_name
        session[:dashboard_id] = Dashboard.find_by_account_id(user.account_id).id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :controller => "dashboard", :action => "home"})
        #redirect_to(:action => "index")
      else
        flash.now[:warning] = "Invalid username/password"
      end
    end
  end

  def logout
    session[:user_id] = nil
    session[:user] = nil
    redirect_to( :action => "login")
  end

  def forgot_password
    if request.post?
      logger.debug "Inside password reset!!!"
      u= User.find_by_email(params[:email])
      if u and u.send_new_password
        flash[:success]  = "A new password has been sent by email."
        redirect_to :action => "login"
      else
        flash[:warning]  = "Couldn't send password"
        redirect_to :action => "login"
      end
    end
  end

  def reset_password
    @user = User.find(session[:user_id])
    if request.post?
      if(params[:password] != params[:password_confirmation])
        flash[:error]="Passwords don't match"
        redirect_to( :action => "reset_password")
      else
        @user.update_attributes(:password=>params[:password], :password_confirmation => params[:password_confirmation])
        if @user.save
          flash[:success]="Password Changed"
        else
          flash[:error]="Couldn't update password"
        end
        redirect_to( :action => "my_account")
      end
    end
  end

  def cancel
    account = session[:account]
    subscription = Chargify::Subscription.find(account.subscription_id)
    subscription.cancel
    account.services.destroy
    account.dashboards.destroy
    account.users.destroy
    account.destroy
    logout
  end




    def index
    end

  end
