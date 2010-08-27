class UserObserver < ActiveRecord::Observer
  def after_create(user)
   new_password =  new_password = user.set_random_password
    Emailer.deliver_welcome_email(user, new_password)
  end
end