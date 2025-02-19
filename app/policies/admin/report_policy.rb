class Admin::ReportPolicy < AdminApplicationPolicy
  def member_export_xlsx?
    user_access_authorized?(:member_export_xlsx)
  end
end
