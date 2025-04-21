require 'rails_helper'

describe Admin::CommentPolicy, type: :policy do
  include_context 'policy_setup'

  describe '#index?' do
    it 'allows access if user has index permission' do
      expect(policy.index?).to be_truthy
    end

    it 'denies access if user does not have index permission' do
      system_role.system_permissions.delete(sp_index)
      expect(policy.index?).to be_falsey
    end
  end

  describe '#show?' do
    it 'allows access if user has show permission' do
      expect(policy.show?).to be_truthy
    end

    it 'denies access if user does not have show permission' do
      system_role.system_permissions.delete(sp_show)
      expect(policy.show?).to be_falsey
    end
  end

  describe '#create?' do
    it 'allows access if user has create permission' do
      expect(policy.create?).to be_truthy
    end

    it 'denies access if user does not have create permission' do
      system_role.system_permissions.delete(sp_create)
      expect(policy.create?).to be_falsey
    end
  end

  describe '#update?' do
    it 'allows access if user has update permission' do
      expect(policy.update?).to be_truthy
    end

    it 'denies access if user does not have update permission' do
      system_role.system_permissions.delete(sp_update)
      expect(policy.update?).to be_falsey
    end
  end

  describe '#archive?' do
    it 'allows access if user has archive permission' do
      expect(policy.archive?).to be_truthy
    end
  end

  describe '#unarchive?' do
    it 'allows access if user has unarchive permission' do
      expect(policy.unarchive?).to be_truthy
    end
  end
end
