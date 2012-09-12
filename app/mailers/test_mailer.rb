class TestMailer < ActionMailer::Base
  default from: "from@example.com"

  def load_settings(mail)
    @@smtp_settings = {
      :address              => mail.server,
      :port                 => mail.port,
     # :domain               => options["domain"],
      :authentication       => :plain,
      :user_name            => mail.username,
      :password             => mail.password
    }
  end

  def test_email(email_address)

    mail = MailSetting.first()
    load_settings(mail)
    mail(:to => email_address, :subject => "Test Email Asset Manager", :from => mail.from_email)
  end
end
