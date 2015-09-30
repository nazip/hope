class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :load_question, only: [:show, :destroy, :update]
  after_action :publish_message, only: :create
  before_action :pundit_authorize, only: [:index, :new, :create]

  respond_to :js, only: :update

  def index
    respond_with(@questions) if stale?(@questions = Question.all)
    # respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = Question.new)
  end

  def show
    respond_with(@answer = @question.answers.build)
  end

  def destroy
    respond_with(@question.destroy)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  private

  def pundit_authorize
    authorize Question.new
  end

  def publish_message
    PrivatePub.publish_to '/questions',
    message: { obj: "#{render_to_string partial: 'question', object: @question, as: 'question'}" } if @question.errors.empty?
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:id])
    authorize @question
  end
end
