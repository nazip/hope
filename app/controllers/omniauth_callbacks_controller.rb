class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :load_user

  def twitter
  end

  def facefook
  end

  private

  def load_user
    session[:oauth] = request.env['omniauth.auth'].except('extra')
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: request.env['omniauth.auth'].provider) if is_navigational_format?
    else
      redirect_to new_user_registration_path
    end
  end
end
