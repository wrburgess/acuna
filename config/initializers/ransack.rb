Ransack.configure do |config|
  # Add a custom predicate for array containment
  config.add_predicate 'array_contains',
                       arel_predicate: 'matches',
                       formatter: proc { |v| v.to_i },
                       validator: proc { |v| v.present? },
                       compounds: true,
                       type: :integer

  # Customize sort link arrows
  config.custom_arrows = {
    up_arrow: '<i class="bi bi-arrow-up"></i>',
    down_arrow: '<i class="bi bi-arrow-down"></i>',
    default_arrow: '<i class="bi bi-arrow-up"></i>'
  }

  # Instead of before_performing_search, we'll rely on the helper method
  # we already added to ApplicationHelper to preserve player_type in sort_link
end
