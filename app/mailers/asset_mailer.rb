class AssetMailer < ActionMailer::Base
  default from: "admin@assetmanager"

  def create()
      mail(:to => 'gparmar@blackboard.com', :subject => "Welcome to My Awesome Site")
    end
end
