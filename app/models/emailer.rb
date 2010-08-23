class Emailer < ActionMailer::Base
  def welcome_email(user)
    logger.debug "Inside welcome email!!!"
    recipients    user.email
    from          "StatusDashboard Site Notifications <notifications@clearsignalsoft.com>"
    subject       "Welcome to StatusDashboard"
    sent_on       Time.now
    body          :user => user, :url => "http://localhost:3000/admin/login"
  end

   def forgot_password(to, login, pass, sent_at = Time.now)
    @subject    = "Your password is ..."
    @body['login']=login
    @body['pass']=pass
    @recipients = to
    @url        = "http://localhost:3000/admin/reset_password"
    @from       = 'support@statusdashboard.com'
    @sent_on    = sent_at
    @headers    = {}
  end

end