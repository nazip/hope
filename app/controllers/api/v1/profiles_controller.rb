class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :load_user

  def me
    respond_with current_user
  end

  def index
    respond_with User.where.not(id: current_user.id)
  end

  private

  def load_user
    authorize current_user
  end
 end
