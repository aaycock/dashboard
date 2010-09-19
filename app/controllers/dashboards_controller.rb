class DashboardsController < ApplicationController
  # GET /dashboards
  # GET /dashboards.xml
  def index
    @account = Account.find(session[:account_id])
    @dashboards = @account.dashboards.all
    #@dashboards = Dashboard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dashboards }
    end
  end

  # GET /dashboards/1
  # GET /dashboards/1.xml
  def show
    @dashboard = Account.find(session[:account_id]).dashboards.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dashboard }
    end
  end

  # GET /dashboards/new
  # GET /dashboards/new.xml
  def new
    @dashboard = Dashboard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dashboard }
    end
  end

  # GET /dashboards/1/edit
  def edit
    @dashboard = Account.find(session[:account_id]).dashboards.find(params[:id])
  end

  # POST /dashboards
  # POST /dashboards.xml
  def create
    @dashboard = Dashboard.new(params[:dashboard])

    respond_to do |format|
      @dashboard.account_id = session[:account_id]
      if @dashboard.save
        format.html { redirect_to("/dashboards", :notice => 'Dashboard was successfully created.') }
        format.xml  { render :xml => @dashboard, :status => :created, :location => @dashboard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dashboard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dashboards/1
  # PUT /dashboards/1.xml
  def update
    @dashboard = Account.find(session[:account_id]).dashboards.find(params[:id])

    respond_to do |format|
      if @dashboard.update_attributes(params[:dashboard])
        format.html { redirect_to(@dashboard, :notice => 'Dashboard was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dashboard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboards/1
  # DELETE /dashboards/1.xml
  def destroy
    if params[:id].to_i == session[:dashboard_id].to_i
      flash[:warning] = "Unable to remove active dashboard (try switching)"
      redirect_to("/dashboards")
      return
    else
      @dashboard = Dashboard.find(params[:id])
      @dashboard.destroy
    end
    respond_to do |format|
      format.html { redirect_to(dashboards_url) }
      format.xml  { head :ok }
    end
  end
end
