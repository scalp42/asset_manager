class MailSettingsController < ApplicationController
  layout 'admin'
  include MailSettingsHelper

  def index
   @mail = MailSetting.first()
   setSidebar(nil,nil,nil,nil,nil,nil,nil,true)
  end

  def create

    mailSetting = MailSetting.new(:name => params[:name][:name],:description => params[:description][:description],:from_email => params[:from_email][:from_email],:server => params[:server][:server],:port => params[:port][:port],:username =>params[:username][:username],:password => params[:password][:password])

    setSidebar(nil,nil,nil,nil,nil,nil,nil,true)

    if mailSetting.save
      @mail = MailSetting.first()
      render :template => 'mail_settings/index'
    end
  end

  def edit

    mailSetting = MailSetting.find(BSON::ObjectId.from_string(params[:mail][:mail_id]))

    mailSetting.name = params[:name][:name]
    mailSetting.description = params[:description][:description]
    mailSetting.from_email = params[:from_email][:from_email]
    mailSetting.server = params[:server][:server]
    mailSetting.port = params[:port][:port]
    mailSetting.username = params[:username][:username]
    mailSetting.password = params[:password][:password]

    setSidebar(nil,nil,nil,nil,nil,nil,nil,true)

    if mailSetting.save
      @mail = MailSetting.first()
      render :template => 'mail_settings/index'
    end
  end

  def send_test_email
    TestMailer.test_email(params[:test_email][:test_email]).deliver
    @mail = MailSetting.first()
    render :template => 'mail_settings/index'
  end

  def delete
    MailSetting.destroy(BSON::ObjectId.from_string(params['mail_setting_id']))
    @mail = MailSetting.first()
    render :template => 'mail_settings/index'
  end

end
