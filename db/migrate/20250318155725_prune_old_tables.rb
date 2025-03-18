class PruneOldTables < ActiveRecord::Migration[8.0]
  def up
    # First drop tables with foreign key dependencies
    drop_table :order_items, if_exists: true
    drop_table :screening_requests, if_exists: true
    drop_table :venues, if_exists: true
    drop_table :orders, if_exists: true

    # Then drop tables without foreign key dependencies
    drop_table :contacts, if_exists: true
    drop_table :inbound_request_logs, if_exists: true
    drop_table :labels, if_exists: true
    drop_table :organizations, if_exists: true
    drop_table :solid_cable_messages, if_exists: true
    drop_table :solid_cache_entries, if_exists: true
    drop_table :storage_asset_service_prices, if_exists: true
    drop_table :storage_asset_sessions, if_exists: true
    drop_table :storage_assets, if_exists: true
    drop_table :titles, if_exists: true
    drop_table :widgets, if_exists: true
  end

  def down
    # This migration is not reversible as table structure would be lost
    raise ActiveRecord::IrreversibleMigration, "Cannot restore dropped tables without their structure definitions"
  end
end
