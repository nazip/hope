class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :init

  def create
    @comment = Comment.new(body: params[:comment][:body],
                           commentable: @obj,
                           user_id: current_user.id)
    return unless @comment.save
    PrivatePub.publish_to "/comments/question/#{@comment.commentable_type=='Question' ? @obj.id : @obj.question.id}",
                          message: { obj: @comment }
    render nothing: true
  end

  private

  def init
    if params.key?(:answer_id)
      @obj = Answer.find(params[:answer_id])
    else
      @obj = Question.find(params[:question_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :question_id, :answer_id)
  end
end
