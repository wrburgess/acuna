# app/policies/admin/comment_policy.rb

module Admin
  class CommentPolicy < ApplicationPolicy
    def index?
      user.admin?
    end

    def show?
      user.admin?
    end

    def create?
      user.admin?
    end

    def update?
      user.admin?
    end

    def archive?
      user.admin?
    end
  end
end
