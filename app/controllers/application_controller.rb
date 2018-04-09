class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # after_action :verify_authorized, except: :index, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  def after_sign_in_path_for(user)
    if user.class.eql?(QuantitySurveyor)
      request_for_tenders_path
    elsif user.class.eql?(Contractor)
      #redirect to contractor dashboard
      contractors_dashboard_path(user.id)
    else
      rails_admin.dashboard_path
    end
  end

  def after_sign_up_path_for(user)
    if user.class.eql?(QuantitySurveyor)
      request_for_tenders_path
    else
      contractors_dashboard_path(user.id)
    end
  end

  def after_inactive_sign_up_path_for(quantity_surveyor)
    rails_admin.new_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name phone_number company_name company_logo])
  end

  def pundit_user
    current_quantity_surveyor
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
