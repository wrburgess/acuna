class Admin::TrackingListButton::Component < ViewComponent::Base
  def initialize(player:, tracking_status: false, options: {})
    @player = player
    @tracking_status = tracking_status
    @options = options
    @css_class = determine_css_class
    @icon_class = determine_icon_class
    @button_text = determine_button_text
  end

  private

  def determine_css_class
    if @tracking_status
      "btn btn-sm btn-danger #{@options[:class]}"
    else
      "btn btn-sm btn-primary #{@options[:class]}"
    end
  end

  def determine_icon_class
    if @tracking_status
      'fas fa-times-circle'
    else
      'fas fa-plus-circle'
    end
  end

  def determine_button_text
    if @tracking_status
      @options[:remove_text] || 'Remove from Tracking'
    else
      @options[:add_text] || 'Add to Tracking'
    end
  end
end
