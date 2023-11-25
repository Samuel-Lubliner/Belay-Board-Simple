class CommentsController < ApplicationController
  before_action :set_availability, only: [:create]
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @availability.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @availability, notice: 'Comment was successfully added.'
    else
      redirect_to @availability, alert: 'Unable to add comment.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.availability, notice: 'Comment was successfully deleted.'
  end

  private

  def set_availability
    @availability = Availability.find(params[:availability_id])
  end
  

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :availability_id)
  end
end
