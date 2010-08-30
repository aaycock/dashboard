class EventsController < ApplicationController

  layout 'events', :except => :show


  # GET /events
  # GET /events.xml
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @edit = params[:admin]
    #if Account.find(session[:account_id]).services.find(params[:id])
      @events = Event.find_by_sql ["select * from events where service_id = ? and  date(timestamp) = ? order by timestamp desc", params[:id], params[:date]]
    #end
    logger.debug "events: #{@events.length}"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
      @event = Event.find(params[:id])
      if !Account.find(session[:account_id]).services.find(@event.service_id)
        @event=nil
      end
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    #if !Account.find(session[:account_id]).services.find(@event.service_id)
     #   @event=nil
     #   return
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to(:controller => :admin, :action => :home, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])
    if !Account.find(session[:account_id]).services.find(@event.service_id)
      return
    end

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to("/home", :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to("/home") }
      format.xml  { head :ok }
    end
  end
end
