class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def after_sign_up_path_for(resource)
    edit_climber_path(resource.climber.id)
  end
end
