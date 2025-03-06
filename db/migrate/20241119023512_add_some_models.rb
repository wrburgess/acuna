class AddSomeModels < ActiveRecord::Migration[8.0]
  def change
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
  end
end
