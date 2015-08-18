class RegistrationsController < Devise::RegistrationsController

  def create
    if session[:oauth]
      @user = User.find_for_oauth(session[:oauth], params[:user][:email])
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: session[:oauth]['provider']) if is_navigational_format?
    end
  end

  private

  def build_resource(*args)
    super
    if session[:oauth]
      password = Devise.friendly_token[0, 20]
      @user.password = password
      @user.password_confirmation = password
      @user.apply_omniauth(session[:oauth])
      @user.valid?
    end
  end
end
