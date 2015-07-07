require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create_list(:question, 2, user: user) }

  describe 'GET #destroy' do
    context 'user can delete his question' do
      before { sign_in user }

      it 'delete from the table question' do
        expect { delete :destroy, id: question[0] }.to change(Question, :count).by(-1)
      end
    end
    context 'user can not delete the question owned by other user' do
      sign_in_user

      it 'do not delete from the table question' do
        expect { delete :destroy, id: question[0] }.to_not change(Question, :count)
      end
    end
  end

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
    sign_in_user
    before { get :show, id: question[0] }

    it 'assing new question to @question' do
      expect(assigns(:question)).to eq question[0]
    end
    it 'create new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'assign new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
    it 'render the show action' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'authenticated user can create question' do
      sign_in_user
      before { get :new }

      it 'assign new question to var question' do
        expect(assigns(:question)).to be_a_new(Question)
      end
      it 'assign new attachment for question' do
        expect(assigns(:question).attachments.first).to be_a_new(Attachment)
      end
      it 'render new view' do
        expect(response).to render_template :new
      end
    end
    context 'non authenticated user can NOT create question' do
      before { get :new }

      it 'render the log_in view' do
        expect(response).to redirect_to :user_session
      end
    end
  end

  describe 'POST #create' do
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
        # expect(Question.last.user_id).to eq user[:id]
        expect(assigns(:question).user).to eq subject.current_user
      end
      it 'redirect to the show action' do
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
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

  describe 'PATCH #update' do
    sign_in_user

    it 'assign question to var question' do
      patch :update, id: question[0], question: attributes_for(:question), format: :js
      expect(assigns(:question)).to eq question[0]
    end

    it "update question's body" do
      patch :update, id: question[0], question: { body: 'New question body' }, format: :js
      assigns(:question).reload
      expect(assigns(:question).body).to eq 'New question body'
    end

    it "render update's template" do
      patch :update, id: question[0], question: attributes_for(:question), format: :js
      expect(response).to render_template :update
    end
  end
end
