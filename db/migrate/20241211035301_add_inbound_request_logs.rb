class AddInboundRequestLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :inbound_request_logs do |t|
      t.string :service, null: false
      t.jsonb :meta, null: false, default: {}
      t.datetime :created_at, null: false
    end
  end
end
