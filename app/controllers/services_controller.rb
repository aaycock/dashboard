class ServicesController < ApplicationController

  # GET /services
  # GET /services.xml
  def index
    user_id = session[:user_id]
    user = User.find(user_id)
    account_id = Account.find(user.account_id)
    @services = Service.find_all_by_dashboard_id(session[:dashboard_id])
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end

  # GET /services/1
  # GET /services/1.xml
  def show
    #@service = Service.find(params[:id])
    @service = Account.find(session[:account_id]).services.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/new
  # GET /services/new.xml
  def new
    @service = Service.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/1/edit
  def edit
    #@service = Service.find(params[:id])
    @service = Account.find(session[:account_id]).services.find(params[:id])
  end

  # POST /services
  # POST /services.xml
  def create
    #logger.debug "account_id: #{params[:account_id]}"
   @account = Account.find(session[:account_id])
   @service = @account.services.create(params[:service])
   @service.dashboard_id = session[:dashboard_id] 
   @service.save

   respond_to do |format|
     format.html { redirect_to("/services", :notice => 'Service was successfully created.')}
     format.js
   end
  end

  # PUT /services/1
  # PUT /services/1.xml
  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        format.html { redirect_to("/services", :notice => 'Service was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to("/services") }
      format.xml  { head :ok }
    end
  end

end
