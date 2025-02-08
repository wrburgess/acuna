class DuplicateSystemPermissionAssociationsJob < ApplicationJob
  include ApplicationHelper

  queue_as :default

  def perform(prev_id, new_id)
    prev_system_permission = SystemPermission.find(prev_id)
    new_system_permission = SystemPermission.find(new_id)

    prev_system_permission.system_roles.each do |system_role|
      new_system_permission.system_roles << system_role
    end
  end
end
