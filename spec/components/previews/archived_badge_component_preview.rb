class ArchivedBadgeComponentPreview < ViewComponent::Preview
  # ArchivedBadgeComponent
  # ------------
  # Default rendering with archived_at present
  #
  # @label Default rendering
  def default_rendering
    render(ArchivedBadge::Component.new(archived_at: Time.zone.now))
  end

  # ArchivedBadgeComponent
  # ------------
  # This scenario renders with arguments provided
  #
  # @param archived_at [String] text
  #
  # @label Variation renderings
  def arguments_provided(archived_at: Time.zone.now)
    render(ArchivedBadge::Component.new(archived_at:))
  end
end
