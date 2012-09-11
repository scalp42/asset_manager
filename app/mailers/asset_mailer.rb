class AssetMailer < ActionMailer::Base
  default from: "admin@assetmanager"

  def create(asset,email_address)

    @asset = asset
    mail(:to => email_address, :subject => "New Asset Created "+@asset.name)
  end

  def edit(asset,email_address)

    @asset = asset
    mail(:to => email_address, :subject => "Updated "+@asset.name)
  end

  def delete(asset,email_address)

    @asset = asset
    mail(:to => email_address, :subject => "Asset Deleted "+@asset.name)
  end

end
