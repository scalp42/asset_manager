class AssetMailer < ActionMailer::Base
  default from: "admin@assetmanager"

  def load_settings
    mail = MailSetting.first()
    @@smtp_settings = {
      :address              => mail.server,
      :port                 => mail.port,
     # :domain               => options["domain"],
      :authentication       => :plain,
      :user_name            => mail.username,
      :password             => mail.password
    }
  end

  def create(asset,email_address)
    load_settings
    @asset = asset
    mail(:to => email_address, :subject => "New Asset Created "+@asset.name)
  end

  def edit(asset,email_address)
    load_settings
    @asset = asset
    mail(:to => email_address, :subject => "Updated "+@asset.name)
  end

  def delete(asset,email_address)
    load_settings
    @asset = asset
    mail(:to => email_address, :subject => "Asset Deleted "+@asset.name)
  end

end
