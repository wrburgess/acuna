class Admin::DashboardPolicy < AdminApplicationPolicy
  def initialize(user, _)
    @user = user
  end

  def index?
    user.has_system_permission?
  end
end
