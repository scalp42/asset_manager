module CloudVendorsHelper

  def setSidebar(assetsMenu,fieldsMenu,usersMenu,indexMenu,notificationMenu,groupMenu = nil,securityMenu = nil,mailMenu = nil,cloudMenu = nil)
    @assetsMenu = assetsMenu
    @fieldsMenu = fieldsMenu
    @usersMenu = usersMenu
    @indexMenu = indexMenu
    @notificationMenu = notificationMenu
    @groupMenu = groupMenu
    @securityMenu = securityMenu
    @mailMenu = mailMenu
    @cloudMenu = cloudMenu
  end

  def vendorAlert(vendorName,vendorAction)
    @vendorName = vendorName
    @vendorAction = vendorAction
  end

  def add_rs_fields(fields,asset)
    cloudVendor = CloudVendor.find(asset.vendor_creds)
    cs = CloudServers::Connection.new(:username => cloudVendor.username, :api_key => cloudVendor.api_key)

    fields.each do |field|
      if field != ''
        case field
          when 'flavor'
            flavor = Field.create(:field_type_id => FieldType.first(:type_name => "Select Field").id ,:description => 'RS Flavor',:name => 'RS Flavor',:locked => true,:vendor_type => cloudVendor.cloud_vendor_type)
              cs.flavors.each do |flavor_rs|
                flavor.field_option.build(:option => flavor_rs[:name],:field_id => flavor.id)
              end
            flavor.save
            asset.asset_screen.build(:field_id => flavor.id.to_s ,:asset_id => asset.id,:required => true)
          when 'operating_system'
            image = Field.create(:field_type_id => FieldType.first(:type_name => "Select Field").id ,:description => 'RS Operating System',:name => 'RS Operating System',:locked => true,:vendor_type => cloudVendor.cloud_vendor_type)
              cs.images.each do |image_rs|
                image.field_option.build(:option => image_rs[:name],:field_id => image.id)
              end
            image.save
            asset.asset_screen.build(:field_id => image.id.to_s ,:asset_id => asset.id,:required => true,:vendor_type => cloudVendor.cloud_vendor_type)
          when 'public_ip'
            public = Field.create(:field_type_id => FieldType.first(:type_name => "Single Line Text Field").id ,:description => 'RS Public IP',:name => 'RS Public IP',:locked => true,:vendor_type => cloudVendor.cloud_vendor_type)
            asset.asset_screen.build(:field_id => public.id.to_s ,:asset_id => asset.id,:required => true)
          when 'private_ip'
            private = Field.create(:field_type_id => FieldType.first(:type_name => "Single Line Text Field").id ,:description => 'RS Private IP',:name => 'RS Private IP',:locked => true,:vendor_type => cloudVendor.cloud_vendor_type)
            asset.asset_screen.build(:field_id => private.id.to_s ,:asset_id => asset.id,:required => true)
        end
      end
    end

    asset.save

  end
end
