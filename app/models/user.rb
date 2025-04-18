class User < ApplicationRecord
  include Archivable
  include Loggable

  devise(
    :confirmable,
    :database_authenticatable,
    :lockable,
    :recoverable,
    :rememberable,
    :timeoutable,
    :trackable,
    :validatable,
  )

  normalizes :email, with: EmailNormalizer

  has_many :data_logs, dependent: :destroy
  has_many :system_group_users, dependent: :destroy
  has_many :system_groups, through: :system_group_users
  has_many :system_roles, through: :system_groups
  has_many :system_permissions, through: :system_roles
  has_many :tracking_lists, dependent: :destroy

  scope :select_order, -> { order(last_name: :asc, first_name: :asc) }

  def self.ransackable_attributes(*)
    %w[
      archived_at
      email
      first_name
      id
      last_name
      updated_at
    ]
  end

  def self.ransackable_associations(*)
    %w[
      system_groups
      tracking_lists
    ]
  end

  def admin?
    true
  end

  def self.options_for_select
    select_order.map { |user| [user.last_name_first_name, user.id] }
  end

  def access_authorized?(resource:, operation:)
    system_permissions.where(resource:, operation:).exists?
  end

  def has_system_permission?
    system_permissions.exists?
  end

  def name
    full_name
  end

  def full_name
    "#{first_name} #{last_name}".titleize.strip
  end

  def last_name_first_name
    return "#{last_name}, #{first_name}".titleize.strip if last_name.present? && first_name.present?
    return last_name.titleize.strip if first_name.blank?

    first_name.titleize.strip if last_name.blank?
  end

  def full_name_and_email
    "#{first_name} #{last_name}".titleize.strip + " (#{email})"
  end
end
