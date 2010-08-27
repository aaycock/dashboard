class AdminController < ApplicationController

  # GET /admin
  # GET /admin.xml
  def home
    @edit = true
    user_id = session[:user_id]
    @offset = params[:offset].to_i
    if @offset.nil?
      @offset = 0
    end
    user = User.find(user_id)
    account_id = Account.find(user.account_id)
    @dashboard = Dashboard.find_by_account_id(account_id)
    #  @dashboard = dashboards[0] Add back when we handle multiple dashboards
    @services = Service.find_all_by_dashboard_id(session[:dashboard_id])

    time = Time.now-@offset.days
    @days = Array[ time, time-1.day, time-2.days, time-3.days, time-4.days ]

    @history_hash = Hash.new

    @services.each do |service|
      @days.each do |day|

          event = Event.find_by_sql ["select * from events where events.service_id = ? and  date(events.timestamp) = date(?)", service.id, day]
        if event.length > 0
          if day.strftime("%m/%d/%Y") != Time.now.strftime("%m/%d/%Y")
            event[0].level = 1
          end
          @history_hash[service.id.to_s + "-" + (day.strftime("%m/%d/%Y"))] = [ service.id, event[0].level, event[0].timestamp.strftime("%Y-%m-%d") ]
          
        end
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end

  # GET /dashboard/1
  # GET /dashboard/1.xml
  def dashboard
    @edit=false
    dashboard_id = params[:id]
    @offset = params[:offset].to_i
    if @offset.nil?
      @offset = 0
    end

    @dashboard = Dashboard.find(dashboard_id)
    @services = Service.find_all_by_dashboard_id(dashboard_id)

    time = Time.now-@offset.days
    @days = Array[ time, time-1.day, time-2.days, time-3.days, time-4.days ]

    @history_hash = Hash.new

    @services.each do |service|
      @days.each do |day|

        event = Event.find_by_sql ["select * from events where events.service_id = ? and  date(events.timestamp) = date(?)", service.id, day]
        if event.length > 0
          if day.strftime("%m/%d/%Y") != Time.now.strftime("%m/%d/%Y")
            event[0].level = 1
          end
          @history_hash[service.id.to_s + "-" + (day.strftime("%m/%d/%Y"))] = [ service.id, event[0].level, event[0].timestamp.strftime("%Y-%m-%d") ]

        end
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end

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
        session[:dashboard_id] = Dashboard.find_by_account_id(user.account_id).id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :action => "home"})
        #redirect_to(:action => "index")
      else
        flash.now[:warning] = "Invalid username/password"
      end
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_id] = nil
    session[:user_id] = nil
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

    def index
    end

  end
