Ransack.configure do |config|
  # Add a custom predicate for array containment
  config.add_predicate 'array_contains',
                       arel_predicate: 'matches',
                       formatter: proc { |v| v.to_i },
                       validator: proc { |v| v.present? },
                       compounds: true,
                       type: :integer
end
