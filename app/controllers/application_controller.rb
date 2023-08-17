class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_authorized, except: :index, unless: :active_admin_controller?
  after_action :verify_policy_scoped, only: :index, unless: :active_admin_controller?

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController) || is_a?(ActiveAdmin::Devise::SessionsController) || is_a?(Admin::DashboardController)
  end
end
