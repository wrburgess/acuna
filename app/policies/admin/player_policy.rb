class Admin::PlayerPolicy < AdminApplicationPolicy
  def dashboard?
    true
    # user_access_authorized?(:dashboard)
  end

  def search?
    true
    # user_access_authorized?(:dashboard)
  end

  def profile?
    true
    # user_access_authorized?(:dashboard)
  end
end
