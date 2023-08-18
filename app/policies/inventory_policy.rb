# frozen_string_literal: true

class InventoryPolicy < ApplicationPolicy
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
    user.role.in?(["admin", "purchase"])
  end

  def show?
    user.role.in?(["admin", "purchase"])
  end

  def create?
    user.role == "admin"
  end

  def new?
    create?
  end

  def update?
    user.role == "admin"
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def verify?
    user.role.in?(["admin", "purchase"]) && record.opened?
  end

  def bulk_verify?
    user.role.in?(["admin", "purchase"])
  end
end
