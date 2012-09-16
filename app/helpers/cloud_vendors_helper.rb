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

  def vendorErrorAlert(vendorErrorName,vendorErrorAction)
    @vendorErrorName = vendorErrorName
    @vendorErrorAction = vendorErrorAction
  end


  def add_rs_fields(fields,asset)
    cloudVendor = CloudVendor.find(asset.vendor_creds)
    cs = CloudServers::Connection.new(:username => cloudVendor.username, :api_key => cloudVendor.api_key)

    fields.each do |field|
      if field != ''
        case field
          when 'flavor'
            if Field.where(:name => 'RS Flavor').count == 0
              flavor = Field.create(:field_type_id => FieldType.first(:type_name => "Select Field").id ,:description => 'RS Flavor',:name => 'RS Flavor',:vendor_type => cloudVendor.cloud_vendor_type,:locked => true)
              cs.flavors.each do |flavor_rs|
                flavor.field_option.build(:option => flavor_rs[:name],:field_id => flavor.id)
              end
              flavor.save
              asset.asset_screen.build(:field_id => flavor.id.to_s ,:asset_id => asset.id,:required => true)
            end
          when 'operating_system'
            if Field.where(:name => 'RS Operating System').count == 0
              image = Field.create(:field_type_id => FieldType.first(:type_name => "Select Field").id ,:description => 'RS Operating System',:name => 'RS Operating System',:vendor_type => cloudVendor.cloud_vendor_type,:locked => true)
              cs.images.each do |image_rs|
                image.field_option.build(:option => image_rs[:name],:field_id => image.id)
              end
              image.save
              asset.asset_screen.build(:field_id => image.id.to_s ,:asset_id => asset.id,:required => true,:vendor_type => cloudVendor.cloud_vendor_type)
            end
          when 'public_ip'
            if Field.where(:name => 'RS Public IP').count == 0
              public = Field.create(:field_type_id => FieldType.first(:type_name => "Single Line Text Field").id ,:description => 'RS Public IP',:name => 'RS Public IP',:vendor_type => cloudVendor.cloud_vendor_type,:locked => true)
              asset.asset_screen.build(:field_id => public.id.to_s ,:asset_id => asset.id,:required => true)
            end
          when 'private_ip'
            if Field.where(:name => 'RS Private IP').count == 0
              private = Field.create(:field_type_id => FieldType.first(:type_name => "Single Line Text Field").id ,:description => 'RS Private IP',:name => 'RS Private IP',:vendor_type => cloudVendor.cloud_vendor_type,:locked => true)
              asset.asset_screen.build(:field_id => private.id.to_s ,:asset_id => asset.id,:required => true)
            end
        end
      end
    end

    asset.save

  end
end
