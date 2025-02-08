require 'rails_helper'

describe 'Admin SystemPermissions', type: :feature do
  include_context 'feature_setup'

  before do
    login_as(user, scope: :user)
  end

  xscenario 'User creates a new instance' do
    visit new_polymorphic_path([:admin, instance.class])

    name = Faker::Company.name
    abbreviation = name[0..2].upcase
    resource = 'User'
    operation = 'create'
    description = Faker::Lorem.sentence
    notes = Faker::Lorem.sentence

    fill_in "#{instance_name}[name]", with: name
    fill_in "#{instance_name}[abbreviation]", with: abbreviation
    fill_in "#{instance_name}[resource]", with: resource

    fill_in_tom_select_field(
      input_selector: '#system_permission_operation',
      ancestor_selector: '.input-group',
      text_value: operation.upcase
    )

    fill_in "#{instance_name}[description]", with: description
    fill_in "#{instance_name}[notes]", with: notes
    click_button 'Submit'

    expect(page).to have_text("New #{instance_name.titleize} successfully created")
    expect(page).to have_text(name)
    expect(page).to have_text(abbreviation)
    expect(page).to have_text(resource)
    expect(page).to have_text(operation.downcase)
    expect(page).to have_text(description)
    expect(page).to have_text(notes)
  end

  scenario 'User views an instance' do
    visit polymorphic_path([:admin, instance])

    expect(page).to have_text(instance.name)
    expect(page).to have_text(instance.abbreviation)
    expect(page).to have_text(instance.resource)
    expect(page).to have_text(instance.operation)
    expect(page).to have_text(instance.description)
    expect(page).to have_text(instance.notes)
  end

  xscenario 'User updates an instance' do
    name = Faker::Company.name
    abbreviation = name[0..2].upcase
    resource = 'Link'
    operation = 'update'
    description = Faker::Lorem.sentence
    notes = Faker::Lorem.sentence

    visit edit_polymorphic_path([:admin, instance])

    fill_in "#{instance_name}[name]", with: name
    fill_in "#{instance_name}[abbreviation]", with: abbreviation
    fill_in "#{instance_name}[resource]", with: resource

    fill_in_tom_select_field(
      input_selector: '#system_permission_operation',
      ancestor_selector: '.input-group',
      text_value: operation.upcase
    )

    fill_in "#{instance_name}[description]", with: description
    fill_in "#{instance_name}[notes]", with: notes
    click_button 'Submit'

    expect(page).to have_text("#{instance_name.titleize} successfully updated")
    expect(page).to have_text(name)
    expect(page).to have_text(abbreviation)
    expect(page).to have_text(resource)
    expect(page).to have_text(operation.downcase)
    expect(page).to have_text(description)
    expect(page).to have_text(notes)
  end

  xscenario 'User deletes an instance' do
    visit polymorphic_path([:admin, instance])

    expect do
      click_link 'Delete'
    end.to change(instance.class, :count).by(-1)

    expect(page).to have_current_path(polymorphic_path([:admin, instance.class]))
    expect(page).to have_text("#{instance_name.titleize} successfully deleted")
    expect { instance.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
