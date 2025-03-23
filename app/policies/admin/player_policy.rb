class Admin::PlayerPolicy < AdminApplicationPolicy
  def dashboard?
    true
    # user_access_authorized?(:dashboard)
  end
end
