class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  respond_to :js

  def destroy
    authorize @attachment
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
