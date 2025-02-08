require 'rails_helper'

describe 'Admin Links', type: :feature do
  include_context 'feature_setup'

  before do
    login_as(user, scope: :user)
  end

  scenario 'User creates a new instance' do
    visit new_polymorphic_path([:admin, instance.class])

    url = Faker::Internet.url
    notes = Faker::Lorem.sentence

    fill_in "#{instance_name}[url]", with: url
    fill_in "#{instance_name}[notes]", with: notes
    click_button 'Submit'

    expect(page).to have_text("New #{instance_name.titleize} successfully created")
    expect(page).to have_text(url)
    expect(page).to have_text(notes)
  end

  scenario 'User views an instance' do
    visit polymorphic_path([:admin, instance])

    expect(page).to have_text(instance.url)
    expect(page).to have_text(instance.notes)
  end

  scenario 'User updates an instance' do
    url = Faker::Internet.url
    notes = Faker::Lorem.sentence

    visit edit_polymorphic_path([:admin, instance])

    fill_in "#{instance_name}[url]", with: url
    fill_in "#{instance_name}[notes]", with: notes
    click_button 'Submit'

    expect(page).to have_text("#{instance_name.titleize} successfully updated")
    expect(page).to have_text(url)
    expect(page).to have_text(notes)
  end

  scenario 'User archives an instance' do
    visit polymorphic_path([:admin, instance])

    expect do
      click_link 'Archive', match: :first
    end.to change(klass.actives, :count).by(-1)

    expect(page).to have_text("#{instance_name.titleize} successfully archived")
  end

  scenario 'User unarchives an instance' do
    instance.update(archived_at: Time.current)

    visit polymorphic_path([:admin, instance])

    expect do
      click_link 'Unarchive', match: :first
    end.to change(klass.actives, :count).by(1)

    expect(page).to have_text("#{instance_name.titleize} successfully unarchived")
  end
end
