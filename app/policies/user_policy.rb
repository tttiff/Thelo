class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    true
  end

  def update?
    true
  end

  def show?
    true
  end

  def dashboard?
    true
  end

  def host_events_dashboard?
    true
  end
end
