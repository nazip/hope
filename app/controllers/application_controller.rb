require "application_responder"

class ApplicationController < ActionController::Base
  # after_action :verify_authorized
  include Pundit
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
   policy_name = exception.policy.class.to_s.underscore

   respond_to do |format|
      format.html do
        flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
        redirect_to(request.referrer || root_path)
      end
      format.json do
        render json: { obj: @elect, error_txt: 'you can not elect to your answer/question' }, status: 403
      end
      format.js { }
   end
  end
end
