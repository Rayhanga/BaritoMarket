class GroupPolicy < ApplicationPolicy
  def index?
    barito_superadmin? || user.can_access_user_group?(record, roles: %i(owner admin))
  end

  def show?
    index?
  end

  def new?
    barito_superadmin?
  end

  def create?
    new?
  end

  def destroy?
    new?
  end

  def see_user_groups?
    barito_superadmin? || user.can_access_user_group?(record)
  end

  def manage_access?
    barito_superadmin? || user.can_access_app_group?(record, roles: %i(owner))
  end
end
