class AddScreeningRequestModel < ActiveRecord::Migration[8.0]
  def change
    drop_table :screening_requests, if_exists: true

    create_table :screening_requests, force: :cascade do |t|
      t.references :user, null: false, foreign_key: true
      t.references :title, null: false, foreign_key: true
      t.string :status
      t.string :request_host
      t.string :phone_number
      t.string :email
      t.string :organization_name
      t.string :organization_type
      t.text :organization_notes
      t.string :organization_social_media
      t.string :business_type
      t.text :requestor_notes
      t.text :staff_notes
      t.text :pricing_notes
      t.string :slug
      t.string :venue_name
      t.string :venue_capacity
      t.string :venue_location
      t.string :venue_country
      t.date :screening_date
      t.string :screening_time
      t.text :screening_date_notes
      t.boolean :is_ticketed
      t.string :ticket_price
      t.string :expected_attendance
      t.string :file_format
      t.text :equipment_notes
      t.text :marketing_notes
      t.text :organization_url
      t.integer :screening_number
      t.string :billing_address
      t.string :billing_phone
      t.string :billing_email
      t.string :fedex_shipping_code
      t.boolean :mailing_list_opt_in
      t.integer :default_amount
      t.integer :agreed_amount
      t.datetime :archived_at
      t.timestamps
      t.index ["title_id"], name: "index_screening_requests_on_title_id"
      t.index ["user_id"], name: "index_screening_requests_on_user_id"
      t.index :status
      t.index :archived_at
      t.index :slug, unique: true
    end
  end
end
