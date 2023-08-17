class UserPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end

  def index?
    user.role == 'admin'
  end

  def show?
    user.role == 'admin'
  end

  def create?
    user.role == 'admin'
  end

  def new?
    create?
  end

  def update?
    user.role == 'admin' && record.role != 'admin'
  end

  def edit?
    update?
  end

  def destroy?
    false
  end
end
