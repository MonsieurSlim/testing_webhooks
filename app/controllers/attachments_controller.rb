class AttachmentsController < ApplicationController
  respond_to :json

  def index
    render json: @attachments
  end

  def show
    render json: @attachment
  end

  def create
    if @attachment.valid? && @attachment.save
      render json: @attachment
    else
      render json: {errors: @attachment.errors.full_messages}, status: 422
    end
  end

  def destroy
    if @attachment.delete
      render json: @attachment
    else
      render json: {errors: @attachment.errors.full_messages}, status: 422
    end
  end

  def download
    # send the file content down here
    send_data(@attachment.file.read, filename: @attachment.filename)
    head :ok
  end

  private

  def attachment_params
    params.require(:attachment).permit(
        :id, :_destroy, :file, :remove_file, :comment_id
    )
  end

  def load_resource
    @project = Project.friendly.find(params[:project_id])
    @ticket = @project.tickets.find(params[:ticket_id])
    if params[:comment_id]
      @comment = @ticket.comments.find(params[:comment_id]) 
      @resource_scope = policy_scope(@comment.attachments)
    else
      @resource_scope = policy_scope(@ticket.attachments)
    end

    case action_name
    when 'download' then
      @attachment = @resource_scope.where(id: params[:id]).first
      authorize @attachment
    end

    super
  end
end