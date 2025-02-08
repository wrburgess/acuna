class AddSomeModels < ActiveRecord::Migration[8.0]
  def change
    create_table "screening_requests", force: :cascade do |t|
      t.references :requestor, foreign_key: { to_table: :users }, null: true
      t.references :organization
      t.references :venue
      t.boolean :is_ticketed
      t.date :screening_date
      t.integer :number_of_screenings
      t.string :screening_start_time
      t.string :billing_address_1
      t.string :billing_address_2
      t.string :billing_city
      t.string :billing_state
      t.string :billing_country
      t.string :billing_email
      t.string :billing_phone
      t.string :email
      t.string :expected_attendance
      t.string :fedex_shipping_code
      t.string :file_format
      t.string :phone_number
      t.string :request_host
      t.string :requestor_name
      t.string :requestor_title_name
      t.text :requestor_notes
      t.string :slug
      t.string :status
      t.string :ticket_price
      t.text :equipment_notes
      t.text :marketing_notes
      t.text :organization_notes
      t.text :organization_url
      t.text :pricing_notes
      t.text :screening_date_notes
      t.text :staff_notes
      t.datetime :archived_at
      t.timestamps
      t.index [:user_id], name: :index_screening_requests_on_user_id
      t.index [:organization_id], name: :index_screening_requests_on_organization_id
      t.index [:venue_id], name: :index_screening_requests_on_venue_id
    end

    create_table :venues, force: :cascade do |t|
      t.references :requestor, foreign_key: { to_table: :users }, null: true
      t.string :name
      t.string :organization_type
      t.string :company_no
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :fax_phone_number
      t.string :office_phone_number_1
      t.string :office_phone_number_2
      t.string :email_address_1
      t.string :email_address_2
      t.string :website_url
      t.string :capacity
      t.text :staff_notes
      t.datetime :archived_at
      t.timestamps
    end

    create_table :organizations, force: :cascade do |t|
      t.string :social_media
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :company_no
      t.string :country
      t.string :email_address_1
      t.string :email_address_2
      t.string :fax_phone_number
      t.string :name
      t.string :office_phone_number_1
      t.string :office_phone_number_2
      t.string :organization_type
      t.string :state
      t.string :website_url
      t.string :zip_code
      t.text :staff_notes
      t.datetime :archived_at
      t.timestamps
    end

    create_table :reports, force: :cascade do |t|
      t.string :name, null: false
      t.text :description
      t.text :sql, null: false
      t.text :staff_notes
      t.datetime :archived_at
      t.timestamps
    end

    create_table :titles, force: :cascade do |t|
      t.integer :avails_id, null: false
      t.string :name, null: false
      t.text :description
      t.text :staff_notes
      t.datetime :archived_at
      t.timestamps
    end
  end
end
