class StorageAssetPolicy < ApplicationPolicy
  def unarchive?
    user_access_authorized?(:unarchive)
  end
end
