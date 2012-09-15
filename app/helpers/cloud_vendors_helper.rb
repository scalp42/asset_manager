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

  def add_rs_fields(fields)
    fields.each do |field|
      if field != ''
        case field
          when 'flavor'
            flavor = Field.new(:field_type_id => FieldType.first(:type_name => "Select Field") ,:description => 'Flavor',:name => 'Flavor')
            if flavor.save

            end
        end
      end
    end
  end
end
