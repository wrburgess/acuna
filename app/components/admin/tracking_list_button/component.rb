class Admin::TrackingListButton::Component < ViewComponent::Base
  def initialize(instance:, tracking_list:, is_tracked: false)
    @instance = instance
    @tracking_list = tracking_list
    @is_tracked = is_tracked
  end

  private

  def tooltip_text
    @is_tracked ? "Remove from #{@tracking_list.name}" : "Add to #{@tracking_list.name}"
  end

  def icon_class
    if @is_tracked
      "bi #{@tracking_list.icon_name_on} text-warning"
    else
      "bi #{@tracking_list.icon_name_off} text-muted"
    end
  end
end
