module NotificationHelper

  def setSidebar(assetsMenu,fieldsMenu,usersMenu,indexMenu,notificationMenu)
    @assetsMenu = assetsMenu
    @fieldsMenu = fieldsMenu
    @usersMenu = usersMenu
    @indexMenu = indexMenu
    @notificationMenu = notificationMenu
  end

  def notificationReturn(notificationName,notificationAction)
    @notificationName = notificationName
    @notificationAction = notificationAction
  end
end
