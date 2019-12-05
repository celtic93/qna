class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @record = @attachment.record

    if current_user.is_author?(@record)
      @attachment.purge
    else
      redirect_to @record
    end
  end
end
