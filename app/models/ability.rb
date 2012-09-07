class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    SecurityScheme.all.each do |security|
      security.create_restrictions[:users].each do |privilegedUsers|
        privilegedUsers.each do |privilegedUser|
          if privilegedUser == user.id.to_s
            can :create, Asset, :asset_type_id => security.asset_type_id.to_s
          end
        end
      end
      security.edit_restrictions[:users].each do |privilegedUsers|
        privilegedUsers.each do |privilegedUser|
          if privilegedUser == user.id.to_s
            can :update, Asset, :asset_type_id => security.asset_type_id.to_s
          end
        end
      end
      security.view_restrictions[:users].each do |privilegedUsers|
        privilegedUsers.each do |privilegedUser|
          if privilegedUser == user.id.to_s
            can :read, Asset, :asset_type_id => security.asset_type_id.to_s
          end
        end
      end
      security.delete_restrictions[:users].each do |privilegedUsers|
        privilegedUsers.each do |privilegedUser|
          if privilegedUser == user.id.to_s
            can :destroy, Asset, :asset_type_id => security.asset_type_id.to_s
          end
        end
      end
    end

  end
end
