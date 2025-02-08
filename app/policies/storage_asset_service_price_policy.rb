class StorageAssetServicePricePolicy < ApplicationPolicy
  def upload?
    user_access_authorized?(:upload)
  end

  def import?
    user_access_authorized?(:import)
  end

  def export_example?
    user_access_authorized?(:export_example)
  end
end
