# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    super(&:build_profile)
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [profile_attributes: %i[zipcode address introduction]])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [profile_attributes: %i[id zipcode address introduction]])
  end

  def after_update_path_for(resource)
    user_path(resource)
  end
end
