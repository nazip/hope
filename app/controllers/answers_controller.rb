class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, except: [:create, :new]
  before_action :load_new_answer, only: :create

  respond_to :js, only: [:update, :destroy, :create]
  respond_to :json, only: :best

  def new
    authorize Answer.new
    respond_with(@answer = Answer.new)
  end

  def create
    authorize Answer.new
    respond_with(@answer.save)
  end

  def destroy
    authorize @answer
    respond_with(@answer.destroy)
  end

  def update
    authorize @answer
    respond_with(@answer.update(answer_params))
  end

  def best
    authorize @answer
    respond_with @answer.update_best do |format|
      format.js { render :update }
    end
  end

  private

    def load_new_answer
      @answer = @question.answers.new(answer_params)
      @answer.user = current_user
    end

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
