class DashboardController < ApplicationController
  
  # GET /home
  # GET /home.xml
  def home
    @edit = true
    user_id = session[:user_id]
    @offset = params[:offset].to_i
    if @offset.nil?
      @offset = 0
    end
    if params[:di]
      session[:dashboard_id] = params[:di]
    end
    #user = User.find(user_id)
    #account = Account.find(user.account_id)
    @dashboard = Dashboard.find(session[:dashboard_id])
    #  @dashboard = dashboards[0] Add back when we handle multiple dashboards
    @services = Service.find_all_by_dashboard_id(session[:dashboard_id])

    time = Time.now-@offset.days
    @days = Array[ time, time-1.day, time-2.days, time-3.days, time-4.days ]

    @history_hash = Hash.new

    @services.each do |service|
      @days.each do |day|

        event = Event.find_by_sql ["select * from events where events.service_id = ? and  date(events.timestamp) = date(?) order by events.timestamp desc", service.id, day]
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

        event = Event.find_by_sql ["select * from events where events.service_id = ? and  date(events.timestamp) = date(?) order by events.timestamp desc", service.id, day]
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
end