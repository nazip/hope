require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create_list(:question, 2, user: user) }
  let!(:user1) { create(:user) }
  let!(:question1) { create(:question, user: user1) }

  let(:obj) {question.first}
  it_behaves_like 'GET #destroy'
  it_behaves_like 'GET #new'
  it_behaves_like 'PATCH #update'

  describe 'GET #index' do
    before { get :index }

    it 'populate array of questions' do
      expect(assigns(:questions).count).to eq 3
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    sign_in_user
    before { get :show, id: question[0] }

    it 'assing new question to @question' do
      expect(assigns(:question)).to eq question[0]
    end
    it 'create new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'render the show action' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    let(:request) { post :create, user_id: subject.current_user, question: attributes_for(:question) }
    let(:bad_request) { post :create, user_id: user, question: attributes_for(:invalid_question) }
    let(:request_path) { '/questions' }

    sign_in_user

    context 'with valid @question' do
      before do
        post :create, user_id: subject.current_user, question: attributes_for(:question)
      end

      it 'saves to the question db' do
        expect do
          post :create, user_id: subject.current_user, question: attributes_for(:question)
        end.to change(Question, :count).by(1)
      end
      it 'the new question owned by assigned user' do
        expect(assigns(:question).user).to eq subject.current_user
      end
      it 'redirect to the show action' do
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    it_behaves_like 'Publishable'

    context 'with invalid @question' do
      it 'does not save to question db' do
        expect do
          post :create, user_id: user, question: attributes_for(:invalid_question)
        end.to_not change(Question, :count)
      end
      it 'redirect to the new action' do
        post :create, user_id: user, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  def destroy_path
    delete :destroy, id: obj
  end
  def new_path
    get :new
  end
  def update_path(option)
    patch :update, id: obj, question: option, format: :js
  end
end
