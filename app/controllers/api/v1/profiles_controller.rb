class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :load_user #, only: :me

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with User.where.not(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
    # @user_list = policy_scope(User.all) if doorkeeper_token
    # authorize  @user_list
    # respond_with policy_scope(User.all) if doorkeeper_token  #  User.where.not(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  private

  def load_user
    @user = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    authorize @user
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  alias_method :current_user, :current_resource_owner
 end
