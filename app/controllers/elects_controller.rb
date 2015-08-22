class ElectsController < ApplicationController
  before_action :authenticate_user!
  before_action :init_obj, only: [:create, :destroy]

  # respond_to :json

  def create
    if @elect.electable.user_id != current_user.id
      @elect.election = params[:like]
      @elect.save
      render json: { q_id: params[:question_id],
                     a_id: params.key?(:answer_id) ? params[:answer_id] : nil,
                     likes: @elect.electable.elects.sum(:election),
                     obj: @elect,
                     action: params[:like] }
    else
      render json: { obj: @elect, error_txt: 'you can not elect to your answer/question' }, status: 422
    end
  end

  # def create
  #   @elect.election = params[:like]
  #   if @elect.electable.user_id != current_user.id
  #     respond_with @elect.save do |format|
  #       format.json { render json: { likes: @elect.electable.elects.sum(:election),
  #                                    obj: @elect,
  #                                    action: params[:like] } }
  #     end
  #   else
  #     respond_with do |format|
  #       format.json {
  #         render json: { obj: @elect, error_txt: 'you can not elect to your answer/question' }, status: 422
  #       }
  #     end
  #   end
  # end

  def destroy
    if @elect.new_record?
      render json: { obj: @elect, error_txt: 'answer/question does not exists' }, status: 422
    else
      @elect.delete
      render json: { q_id: params[:question_id],
                     a_id: params.key?(:answer_id) ? params[:answer_id] : nil,
                     likes: @elect.electable.elects.sum(:election),
                     obj: @elect,
                     action: 0 }
    end
  end

  # def destroy
  #   if @elect.new_record?
  #     respond_with do |format|
  #       format.json { render json: { obj: @elect, error_txt: 'answer/question does not exists' }, status: 422 }
  #     end
  #   else
  #     respond_with @elect.delete do |format|
  #       format.json { render json: { likes: @elect.electable.elects.sum(:election),
  #                                    obj: @elect,
  #                                    action: 0 }}
  #     end
  #   end
  # end

  private

  def init_obj
    @elect = Elect.find_or_initialize_by(electable_type: params.key?(:answer_id) ? 'Answer' : 'Question',
                                         electable_id: params.key?(:answer_id) ? params[:answer_id] : params[:question_id],
                                         user_id: current_user.id)
  end
end
