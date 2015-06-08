require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create_list(:question, 2) }

  describe 'GET #index' do
    before { get :index }

    it 'populate array of questions' do
      expect(assigns(:questions)).to match_array(question)
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assing new question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'render the show action' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assign new question to var question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid @question' do
      it 'saves to the question db' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'redirect to the show action' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid @question' do
      it 'does not save to question db' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 'redirect to the new action' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end
end
