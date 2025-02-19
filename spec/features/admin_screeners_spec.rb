require 'rails_helper'

describe 'Admin Screeners', type: :feature do
  include_context 'feature_setup'

  before do
    login_as(user, scope: :user)
  end

  scenario 'User creates a new screener' do
    visit new_admin_screener_path

    name = Faker::Name.name
    amount = Faker::Number.number(digits: 4)

    fill_in 'screener[name]', with: name
    fill_in 'screener[amount]', with: amount
    click_button 'Submit'

    expect(page).to have_text('New Screener successfully created')
    expect(page).to have_text(name)
    expect(page).to have_text(amount)
  end

  scenario 'User views a screener' do
    screener = create(:screener)
    visit admin_screener_path(screener)

    expect(page).to have_text(screener.name)
    expect(page).to have_text(screener.amount)
  end

  scenario 'User updates a screener' do
    screener = create(:screener)
    visit edit_admin_screener_path(screener)

    name = Faker::Name.name
    fill_in 'screener[name]', with: name
    click_button 'Submit'

    expect(page).to have_text('Screener successfully updated')
    expect(page).to have_text(name)
  end

  scenario 'User archives a screener' do
    screener = create(:screener)
    visit admin_screener_path(screener)

    expect do
      click_link 'Archive', match: :first
    end.to change(Screener.actives, :count).by(-1)

    expect(page).to have_text('Screener successfully archived')
  end

  scenario 'User unarchives a screener' do
    screener = create(:screener, archived_at: Time.current)
    visit admin_screener_path(screener)

    expect do
      click_link 'Unarchive', match: :first
    end.to change(Screener.actives, :count).by(1)

    expect(page).to have_text('Screener successfully unarchived')
  end
end
