require 'rails_helper'

describe 'Admin Dashboard', type: :feature do
  let(:user) { create(:user) }
  let(:system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }
  let(:sp_index) { create(:system_permission, name: 'Dashboard Index', resource: 'Dashboard', operation: 'index') }
  let(:policy) { described_class.new(user, :dashboard) }

  context 'when user is authorized' do
    scenario 'User visits dashboard' do
      system_role.system_permissions << sp_index
      system_group.system_roles << system_role
      system_group.users << user

      login_as(user, scope: :user)

      visit admin_root_path

      expect(page).to have_current_path(admin_root_path)
      expect(page).to have_text('Dashboard')
    end
  end

  context 'when user is not authenticated' do
    scenario 'User is redirected from dashboard to login' do
      visit admin_root_path

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_text('You need to sign in')
    end
  end

  context 'when user is not authorized' do
    scenario 'User is redirected from dashboard' do
      login_as(user, scope: :user)

      visit admin_root_path

      expect(page).to have_current_path(admin_root_path)
      expect(page).to have_text("You don't have permission to access this page")
    end
  end
end
