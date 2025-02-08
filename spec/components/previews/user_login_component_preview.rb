class UserLoginComponentPreview < ViewComponent::Preview
  # UserLoginComponent
  # ------------
  # Default rendering with current_user present
  #
  # @label Logged In rendering
  def default_rendering
    render(UserLogin::Component.new(user_signed_in: true))
  end

  # UserLoginComponent
  # ------------
  # This scenario renders with current_user not present
  #
  # @label Logged Out rendering
  def arguments_provided
    render(UserLogin::Component.new(user_signed_in: false))
  end
end
