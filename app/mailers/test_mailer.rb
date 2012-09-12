class TestMailer < ActionMailer::Base
  default from: "from@example.com"

  def test_email(email_address)
    mail = MailSetting.first()

    ActionMailer::Base.smtp_settings = {
    :address => mail.server,
    :port => mail.port,
    :authentication => :plain,
    :user_name => mail.username,
    :password => mail.password
    }

    mail(:to => email_address, :subject => "Test Email Asset Manager", :from => mail.from_email)
  end
end
