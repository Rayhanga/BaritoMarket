class AppGroupPolicy < ApplicationPolicy
  def show?
    barito_superadmin? || user.can_access_app_group?(record)
  end

  def new?
    barito_superadmin?
  end

  def create?
    new?
  end

  def update?
    barito_superadmin?
  end

  def update_app_group_name?
    barito_superadmin? || user.can_access_app_group?(record, roles: %i(owner admin))
  end

  def manage_access?
    barito_superadmin? || user.can_access_app_group?(record, roles: %i(owner))
  end

  def see_app_groups?
    barito_superadmin? || user.can_access_app_group?(record)
  end

  def set_status?
    barito_superadmin? || user.can_access_app_group?(record, roles: %i(owner))
  end

  class Scope < Scope
    def resolve
      if Figaro.env.global_viewer == 'true' &&
          (get_user_groups(user).uniq.include?('barito-superadmin') ||
            get_user_groups(user).uniq.include?(Figaro.env.global_viewer_role))
        return scope.active
      end

      return scope.active if get_user_groups(user).include?('barito-superadmin')
      user.filter_accessible_app_groups(scope.active)
    end

    def get_user_groups(user)
      user_groups = []
      user.groups.each do |group|
        user_groups << group.name
      end
      user_groups
    end
  end
end
