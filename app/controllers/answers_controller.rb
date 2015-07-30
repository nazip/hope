class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, except: [:new, :destroy, :update, :best]
  before_action :load_answer, except: [:create, :new]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:notice] = 'Ответ удален'
    else
      flash[:notice] = 'Ответ не может быть удален'
    end
  end

  def update
    @answer.update(answer_params)
    @answer.reload
    @question = @answer.question
  end

  def best
    @answer.update_best
    render :update
  end

  private

    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body, :best, :user_id, attachments_attributes: [:file])
    end
end
