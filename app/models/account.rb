class Account < ActiveRecord::Base
  #validates_presence_of :name, :contact_email
  has_many :services
  has_many :users

  # Create a new customer
  def create_chargify_customer
    customer = Chargify::Customer.create(
      :first_name   => self.contact_firstname,
      :last_name    => self.contact_lastname,
      :email        => self.contact_email,
      :organization => self.name,
      :reference    => self.id
    )
    self.customer_id = customer.id
    self.save
    #store account-chargify id map in customer_account
  end

  def create_chargify_subscription
    logger.debug "customer: #{self.customer_id}, product: #{self.plan}"
    subscription = Chargify::Subscription.create(
      :customer_id => self.customer_id,
      :product_handle => self.plan
      #:credit_card_attributes => {
      #  :first_name => cc.first_name,
      #  :last_name => cc_last_name,
      #  :expiration_month => cc.exp_month,
      #  :expiration_year => cc.exp_year,
      #  :full_number => cc.number
      #}
    )
    self.subscription_id = subscription.id
    self.save
    # => #<Chargify::Subscription:0x1020ed4b0 @prefix_options={}, @attributes={"cancellation_message"=>nil, "activated_at"=>Tue Nov 17 16:00:17 UTC 2009, "expires_at"=>nil, "updated_at"=>Tue Nov 17 16:00:17 UTC 2009, "credit_card"=>#<Chargify::Subscription::CreditCard:0x102046b10 @prefix_options={}, @attributes={"card_type"=>"bogus", "expiration_year"=>2020, "masked_card_number"=>"XXXX-XXXX-XXXX-1", "first_name"=>"Michael", "expiration_month"=>1, "last_name"=>"Klett"}>, "product"=>#<Chargify::Product:0x10204a2d8 @prefix_options={}, @attributes={"price_in_cents"=>0, "name"=>"Chargify API Ares Test", "handle"=>"chargify-api-ares-test", "product_family"=>#<Chargify::Product::ProductFamily:0x1020490b8 @prefix_options={}, @attributes={"name"=>"Chargify API ARes Test", "handle"=>"chargify-api-ares-test", "id"=>79, "accounting_code"=>nil}>, "id"=>153, "accounting_code"=>nil, "interval_unit"=>"month", "interval"=>1}>, "credit_card_attributes"=>#<Chargify::Subscription::CreditCardAttributes:0x1020ecab0 @prefix_options={}, @attributes={"expiration_year"=>2020, "full_number"=>"1", "first_name"=>"Michael", "expiration_month"=>1, "last_name"=>"Klett"}>, "trial_ended_at"=>nil, "id"=>331, "current_period_ends_at"=>Thu Dec 17 16:00:17 UTC 2009, "product_handle"=>"chargify-api-ares-test", "trial_started_at"=>nil, "customer"=>#<Chargify::Customer:0x10204b688 @prefix_options={}, @attributes={"reference"=>"moklett", "updated_at"=>Tue Nov 17 15:51:02 UTC 2009, "id"=>331, "first_name"=>"Michael", "organization"=>"Chargify", "last_name"=>"Klett", "email"=>"moklett@example.com", "created_at"=>Tue Nov 17 15:51:02 UTC 2009}>, "balance_in_cents"=>0, "current_period_started_at"=>Tue Nov 17 16:00:17 UTC 2009, "state"=>"active", "created_at"=>Tue Nov 17 16:00:17 UTC 2009, "customer_reference"=>"moklett"}>

  end

end
