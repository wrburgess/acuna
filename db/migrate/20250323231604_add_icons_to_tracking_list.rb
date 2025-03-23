class AddIconsToTrackingList < ActiveRecord::Migration[8.0]
  def change
    add_column :tracking_lists, :icon_name_on, :string
    add_column :tracking_lists, :icon_name_off, :string
  end
end
