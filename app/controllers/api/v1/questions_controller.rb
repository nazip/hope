class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :answers]

  def index
    authorize Question.new
    respond_with Question.all, each_serializer: QuestionsSerializer
  end

  def show
    respond_with @question, each_serializer: QuestionSerializer
  end

  def answers
    respond_with Answer.where(question_id: @question), serializer: nil, each_serializer: AnswerSerializer
  end

  def create
    authorize Question.new
    respond_with(@question = current_user.questions.create(question_params))
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
    authorize @question
  end
end
