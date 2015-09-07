class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: :show
   before_action :load_new_answer, only: :create

  def show
    respond_with @answer, each_serializer: AnswerSerializer
  end

  def create
    authorize @answer
    @answer.save
    respond_with @answer
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
    authorize @answer
  end

  def load_new_answer
    @answer = Question.find(params[:question_id]).answers.new(answer_params)
    @answer.user = current_user
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
