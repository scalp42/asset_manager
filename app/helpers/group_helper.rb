module GroupHelper

  def setSidebar(assetsMenu,fieldsMenu,usersMenu,indexMenu,notificationMenu,groupMenu = nil)
    @assetsMenu = assetsMenu
    @fieldsMenu = fieldsMenu
    @usersMenu = usersMenu
    @indexMenu = indexMenu
    @notificationMenu = notificationMenu
    @groupMenu = groupMenu
  end

  def groupReturn(groupName,groupAction)
    groupName = groupName
    groupAction = groupAction
  end

  def findUsersNotInGroup(group_id)
    users = Array.new

    Group.find(BSON::ObjectId.from_string(group_id)).membership.each do |membership|

    end

  end
end
