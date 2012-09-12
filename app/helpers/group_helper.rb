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
    @groupName = groupName
    @groupAction = groupAction
  end

  def findUsersNotInGroup(group_id)
    users = Array.new

    User.each do |user|
      userFound = false
      Group.find(group_id).membership.each do |membership|
         if membership.user_id == user.id
          userFound = true
         end
      end

      unless userFound
        users.push(user)
      end
    end

    return users
  end

  def getUsersInGroup(group_id)
    users = Array.new

    Group.find(group_id).membership.each do |membership|
      users.push(User.find(membership.user_id))
    end

    return users
  end


  def isUserMemberOf(user,group_id)

    if Group.where(:id => group_id,'membership.user_id'=>user.id).count > 0
      return true
    end

    return false
  end

end
