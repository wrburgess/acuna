class ScreeningRequestPolicy < ApplicationPolicy
  def create?
    true
  end

  def show?
    true
  end

  def edit?
    true
  end

  def update?
    true
  end

  def new?
    true
  end

  def index?
    true
  end
end
