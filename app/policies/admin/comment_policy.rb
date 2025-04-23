class Admin::CommentPolicy < AdminApplicationPolicy
  def permitted_attributes
    [:body, :commentable_id, :commentable_type, :user_id]
  end
end