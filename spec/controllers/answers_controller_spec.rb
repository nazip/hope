require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }

  describe 'GET #new' do
    before do
      Answer.stub(:new)

      get :new, question_id: question
    end

    it 'calls new' do
      expect(Answer).to have_received(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid answer' do
      it 'saved to the table answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end
      it 'redirect to the question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(assigns(:answer)).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid answer' do
      it 'do not save to table answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalidanswer) }.to_not change(Answer, :count)
      end
      it 'render questions/show' do
        post :create, question_id: question, answer: attributes_for(:invalidanswer)
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
