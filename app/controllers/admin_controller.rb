class AdminController < ApplicationController
  include Pagy::Backend

  layout 'admin'

  before_action :authenticate_user!

  protected

  # Returns the appropriate Admin namespace policy class
  def policy_class
    class_name = self.class.name.split('::').last.gsub('Controller', '').singularize

    # Attempt to find and return the actual policy class
    "Admin::#{class_name}Policy".constantize
  rescue NameError
    # If the class doesn't exist yet, create a module path that Pundit can use
    Admin.const_get(class_name)
  end

  # Tell Pundit to use Admin namespace policies
  def authorize(record, query = nil)
    # Get the model name for the record without 'Policy' suffix if it exists
    record_name = if record.is_a?(Class)
                    record.name.gsub(/Policy$/, '')
                  else
                    record.class.name
                  end

    # Strip out any existing Policy suffix to avoid duplication
    base_name = record_name.gsub(/Policy$/, '')

    # Determine the appropriate policy class in Admin namespace
    policy_class = "Admin::#{base_name.demodulize}Policy".constantize

    super(record, query, policy_class: policy_class)
  end
end
