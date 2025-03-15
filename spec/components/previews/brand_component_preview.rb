class BrandComponentPreview < ViewComponent::Preview
  # BrandComponent
  # ------------
  # Default rendering with no environment argument provided
  #
  # @label Default rendering
  def default_rendering
    render(Brand::Component.new)
  end

  # BrandComponent
  # ------------
  # Renders with all arguments provided
  #
  # @param brand_name [String] text "Name of application or firm"
  # @param environment_name [String] select { choices: [development, test, staging, production] } "Name of application environment"
  # @param classes [String] text "CSS classes for compnent"
  #
  # @label Variation renderings
  def arguments_provided(brand_name: 'Acuna Admin', environment_name: 'staging', classes: 'navbar-brand')
    render(Brand::Component.new(brand_name:, environment_name:, classes:))
  end
end
