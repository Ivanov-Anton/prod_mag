class ActiveAdmin::PagePolicy < ApplicationPolicy
  def show?
    user.seo? || user.manager? || (user.guest? && record.name == 'Dashboard')
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
     scope.all
    end
  end
end
