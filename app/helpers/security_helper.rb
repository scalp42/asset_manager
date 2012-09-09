module SecurityHelper

  def securityReturn(securityName,securityAction)
    @securityName = securityName
    @securityAction = securityAction
  end

  def setSidebar(assetsMenu,fieldsMenu,usersMenu,indexMenu,notificationMenu,groupMenu = nil,securityMenu = nil)
    @assetsMenu = assetsMenu
    @fieldsMenu = fieldsMenu
    @usersMenu = usersMenu
    @indexMenu = indexMenu
    @notificationMenu = notificationMenu
    @groupMenu = groupMenu
    @securityMenu = securityMenu
  end

  def asset_type_no_security()
    assetTypes = Array.new
  end
end
