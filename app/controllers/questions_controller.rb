class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :load_question, only: [:show, :edit, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
  end

  def edit
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
      redirect_to @question
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
