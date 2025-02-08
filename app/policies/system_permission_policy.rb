class SystemPermissionPolicy < ApplicationPolicy
  def copy?
    user_access_authorized?(:copy)
  end
end
