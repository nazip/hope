class RegistrationsController < Devise::RegistrationsController

  def create
    super
    session[:oauth] = nil unless @user.new_record?
  end

  private
  def build_resource(*args)
binding.pry
    super
    if session[:oauth]
      @user.apply_omniauth(session[:oauth])
      @user.valid?
    end
  end
end
