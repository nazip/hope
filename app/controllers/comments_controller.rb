class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :init, only: :create
  after_action :publish_message, only: :create

  def create
    authorize Comment.new(commentable: @obj)
    respond_with @comment = Comment.create(body: params[:comment][:body],
                           commentable: @obj,
                           user_id: current_user.id) do |format|
      format.html { render nothing: true }
    end
  end

  private

  def publish_message
    PrivatePub.publish_to("/comments/question/#{@comment.commentable_type=='Question' ? @obj.id : @obj.question.id}",
                          message: { obj: @comment }) if @comment.errors.empty?
  end

  def init
    @obj = Question.find(params[:question_id]) if params.key?(:question_id)
    @obj ||= Answer.find(params[:answer_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :question_id, :answer_id)
  end
end
