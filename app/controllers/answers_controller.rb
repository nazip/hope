class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:notice] = 'Ответ удален'
    else
      flash[:notice] = 'Ответ не может быть удален'
    end
    redirect_to root_path
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
