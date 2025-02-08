class ActionButtonComponentPreview < ViewComponent::Preview
  # @!group Standard renderings
  #
  # ActionButton::Component
  # ------------
  # Component for an admin interface button
  def rendering_copy
    resource = Link.order('RANDOM()').first
    render(ActionButton::Component.new(operation: :copy, instance: resource))
  end

  def rendering_destroy
    resource = Link.order('RANDOM()').first
    render(ActionButton::Component.new(operation: :destroy, instance: resource))
  end

  def rendering_edit
    resource = Link.order('RANDOM()').first
    render(ActionButton::Component.new(operation: :edit, instance: resource))
  end

  def rendering_edit_link
    resource = Link.order('RANDOM()').first
    render(ActionButton::Component.new(operation: :edit, instance: resource, button_classes: :none, icon_classes: :none))
  end

  def rendering_export_xlsx
    resource = Link.order('RANDOM()').first
    render(ActionButton::Component.new(operation: :export_xlsx, instance: resource))
  end

  def rendering_index
    resource = User.order('RANDOM()').first
    render(ActionButton::Component.new(operation: :index, instance: resource))
  end

  def rendering_new
    resource = Link.order('RANDOM()').first
    render(ActionButton::Component.new(operation: :new, instance: resource))
  end

  def rendering_show
    resource = Link.order('RANDOM()').first
    render(ActionButton::Component.new(operation: :show, instance: resource))
  end

  def rendering_show_link
    resource = Link.order('RANDOM()').first
    render(ActionButton::Component.new(operation: :show, instance: resource, button_classes: :none, icon_classes: :none))
  end
  # @!endgroup

  # ActionButton::Component
  # ------------
  # Component for an admin interface button
  #
  # @param button_classes [String] text "CSS classes to override for button"
  # @param classes_append [String] text "Append CSS classes to button classes"
  # @param icon_classes [String] text "CSS classes to override for icon"
  # @param method [Symbol] select { choices: [delete, get, post] }
  # @param operation [Symbol] select { choices: [copy, destroy, edit, export_xlsx, index, new] }
  # @param path [String] text "Path to override link for button"
  # @param text [String] text "Text to override on button"
  #
  # @label Variation renderings
  def with_arguments(operation: :new, path: '/', text: 'Test', button_classes: 'btn btn-primary', classes_append: 'me-2', icon_classes: 'bi bi-emoji-smile', method: :get)
    resource = Title.order('RANDOM()').first
    render(ActionButton::Component.new(operation:, instance: resource, path:, text:, button_classes:, classes_append:, icon_classes:, method:))
  end
end
