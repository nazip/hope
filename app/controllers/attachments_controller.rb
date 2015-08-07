class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  respond_to :js

  def destroy
    respond_with(@attachment.destroy) if current_user.id == @attachment.attachable.user_id
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
