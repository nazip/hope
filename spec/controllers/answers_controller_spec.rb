require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, best: false, question: question, user: user) }

  let(:obj) {answer}
  it_behaves_like 'GET #destroy'
  it_behaves_like 'GET #new'
  it_behaves_like 'PATCH #update'

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

  describe 'POST #best' do
    context 'authenticated user' do
      before { sign_in user }

      it 'update the best field' do
        patch :best, question_id: question, id: answer, format: :js
        expect(answer.reload.best).to eq true
      end
      it "render update's template" do
        patch :best, question_id: question, id: answer, format: :js
        expect(response).to render_template :update
      end
    end

    context 'non authenticated user' do
      it 'can not update the best field' do
        patch :best, question_id: question, id: answer, format: :js
        expect(answer.reload.best).to eq false
      end
    end
  end
  def destroy_path
    delete :destroy, id: answer, question_id: question, format: :js
  end
  def new_path
    get :new, id: answer, question_id: question
  end
  def update_path(option)
    patch :update, id: answer, question_id: question, answer: option, format: :js
  end
end
