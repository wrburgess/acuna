class AdminApplicationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def user_access_authorized?(operation)
    true if operation
    # user.access_authorized?(resource: record.name, operation:)
  end

  def index?
    true
    # user_access_authorized?(:index)
  end

  def show?
    true
    # user_access_authorized?(:show)
  end

  def new?
    true
    # user_access_authorized?(:new)
  end

  def create?
    true
    # user_access_authorized?(:create)
  end

  def edit?
    true
    # user_access_authorized?(:edit)
  end

  def update?
    true
    # user_access_authorized?(:update)
  end

  def destroy?
    true
    # user_access_authorized?(:destroy)
  end

  def archive?
    true
    # user_access_authorized?(:archive)
  end

  def unarchive?
    true
    # user_access_authorized?(:unarchive)
  end

  def collection_export_xlsx?
    true
    # user_access_authorized?(:collection_export_xlsx)
  end

  def member_export_xlsx?
    true
    # user_access_authorized?(:member_export_xlsx)
  end
end
