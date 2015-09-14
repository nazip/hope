class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :init_obj

  respond_to :js

  def create
    @subscription.save if @subscription.new_record?
  end

  def destroy
    @subscription.destroy unless @subscription.new_record?
    render :create
  end

  private

  def subscriber_params
    params.require(:subscription).permit(:question_id, :id)
  end

  def init_obj
    @subscription = Subscription.find_or_initialize_by(subscriptionable_type: 'Question',
                                         subscriptionable_id: params.key?(:question_id) ? params[:question_id] : params[:id],
                                         user: current_user)
    authorize @subscription
  end

end
