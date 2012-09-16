module ApplicationHelper
  def can_view(asset_type_id)
    ability = Ability.new(current_user,asset_type_id)

    ability.can?(:read,Asset)
  end

  def can_edit(asset_type_id)
    ability = Ability.new(current_user,asset_type_id)

    ability.can?(:update,Asset)
  end

  def can_create(asset_type_id)
    ability = Ability.new(current_user,asset_type_id)

    ability.can?(:create,Asset)
  end

  def can_destroy(asset_type_id)
    ability = Ability.new(current_user,asset_type_id)

    ability.can?(:destroy,Asset)
  end
end
