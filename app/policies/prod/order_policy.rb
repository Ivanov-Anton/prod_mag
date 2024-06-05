class Prod::OrderPolicy < ApplicationPolicy
  def index?
    user.manager? || user.seo?
  end

  def show?
    user.manager? || user.seo?
  end

  def update?
    user.manager? || user.seo?
  end

  def create?
    user.manager? || user.seo?
  end

  def destroy?
    user.seo?
  end

  Scope = Class.new(ApplicationPolicy::Scope)
end
