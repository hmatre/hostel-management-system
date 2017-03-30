class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private
	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role_type, :first_name, :last_name, :age, :address, :pincode])
  end

  def after_sign_in_path_for(resource)
  		user_hostels_path(current_user)
  end

  def after_sign_out_path_for(resource)
  	root_path
  end
end