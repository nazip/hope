class RegistrationsController < Devise::RegistrationsController
  def create
    super
    if session[:oauth]
      @user = User.find_for_oauth(session[:oauth], params[:user][:email])
      session[:oauth] = nil
    end
  end

  private

  def build_resource(*args)
    super
    if session[:oauth]
      if params[:action] == 'create'
        @exist_user = User.where(email: params[:user][:email]).first
        @user = @exist_user if @exist_user
      end
      password = Devise.friendly_token[0, 20]
      @user.password ||= password
      @user.password_confirmation ||= password
      @user.apply_omniauth(session[:oauth])
    end
  end
end
