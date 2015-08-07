class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, except: [:new, :destroy, :update, :best]
  before_action :load_answer, except: [:create, :new]
  before_action :load_new_answer, only: :create
  before_action :test_user, only: [:destroy, :update]

  respond_to :js, only: [:update, :destroy, :create]
  respond_to :json, only: :best

  def new
    respond_with(@answer = Answer.new)
  end

  def create
    respond_with(@answer.save)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    respond_with(@answer.update(answer_params))
  end

  def best
    respond_with @answer.update_best do |format|
      format.js {render :update}
    end
  end

  private

    def test_user
      return if @answer.user_id == current_user.id
      flash[:notice] = 'You have not permition for this operation'
      redirect_to root_path
    end

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
