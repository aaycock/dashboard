class Emailer < ActionMailer::Base
  def welcome_email(user)
    recipients    user.email
    from          "StatusDashboard <notifications@clearsignalsoft.com>"
    subject       "Welcome to StatusDashboard"
    sent_on       Time.now
    body          :user => user, :url => "http://statusdashboard.com/admin/login"
  end

   def forgot_password(to, login, pass, sent_at = Time.now)
    @subject    = "StatusDashboard Password Reset"
    @body['login']=login
    @body['pass']=pass
    @recipients = to
    @url        = "http://statusdashboard.com/admin/reset_password"
    @from       = 'StatusDashboard <notifications@clearsignalsoft.com>'
    @sent_on    = sent_at
    @headers    = {}
  end

end