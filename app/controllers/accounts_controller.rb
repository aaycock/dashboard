class AccountsController < ApplicationController  
  
  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
      format.json { render :json => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
      format.json { render :json => @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
      format.json { render :json => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|


      if @account.save

        # create initial dashboard
        dashboard = Dashboard.new
        dashboard.name = @account.name + " Dashboard"
        dashboard.account_id = @account.id
        dashboard.save

        #send welcome mail to user
        @user = User.new
        @user.account_id = @account.id
        @user.first_name = @account.contact_firstname
        @user.last_name = @account.contact_lastname
        @user.email = @account.contact_email
        logger.debug "Creating user #{@user.email}"
        new_password = @user.set_random_password
        #new_password = user.set_random_password
        #Emailer.deliver_welcome_email(user, new_password)
        @user.save
        format.html { redirect_to("/success.html", :notice => 'Account was successfully created.') }
        #Send welcome mail
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to("/home", :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end

  private
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      name == "admin" && password == "password"
    end
  end
end
