class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :load_question, only: [:show, :edit, :destroy, :update, :elect]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      flash[:notice] = 'Вопрос удален'
    else
      flash[:notice] = 'Это чужой вопрос'
    end
    redirect_to questions_path
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      PrivatePub.publish_to '/questions',
      message: { obj: "#{render_to_string partial: 'question', object: @question, as: 'question'}" }
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
