require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  # let(:question) { create(:question) }

  describe 'GET #destroy' do
    context 'user can delete his answer' do
      before { sign_in user }

      it 'delete from the table answer' do
        expect do
          delete :destroy, id: answer, question_id: question
        end.to change(Answer, :count).by(-1)
      end
      it 'render the questions#index' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to root_path
      end
    end
    context 'user can not delete the answer owned by other user' do
      sign_in_user

      it 'do not delete from the table answer' do
        expect { delete :destroy, id: answer, question_id: question }.to_not change(Answer, :count)
      end
      it 'render the questions#index' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #new' do
    context 'authenticated user can create answer' do
      sign_in_user
      before { get :new, id: answer, question_id: question  }

      it 'assign new answer to var answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end
      it 'render new view' do
        expect(response).to render_template :new
      end
    end
    context 'non authenticated user can NOT create answer' do
      before { get :new, id: answer, question_id: question  }

      it 'render the log_in view' do
        expect(response).to redirect_to :user_session
      end
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid answer (signed user)' do
      it 'saved to the table answer' do
        expect do
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        end.to change(question.answers, :count).by(1)
      end
      it 'created answer owned by signed user' do
        expect(Answer.last.user_id).to eq user.id
      end
      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end
    context 'with invalid answer (signed user)' do
      it 'do not save to table answer' do
        expect do
          post :create, question_id: question, answer: attributes_for(:invalidanswer), format: :js
        end.to_not change(Answer, :count)
      end
      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:invalidanswer), format: :js
        expect(response).to render_template :create
      end
    end
  end
end
