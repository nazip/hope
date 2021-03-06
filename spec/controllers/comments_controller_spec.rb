require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:request) { post :create, controller: :comments, question_id: question.id, user_id: user.id, comment: {body: 'new comment'} }
  let(:bad_request) { post :create, question_id: question.id, user_id: user.id, comment: {body: ''} }
  let(:request_path) { "/comments/question/#{question.id}" }

  describe 'POST #create' do
    context 'authenticated user can comment to q/a' do
      before { sign_in user }

      it 'save to the comment db' do
        expect do
          post :create, controller: :comments, question_id: question.id, user_id: user.id, comment: {body: 'new comment'}
        end.to change(Comment, :count).by(1)
      end
      it_behaves_like 'Publishable'
    end
    context 'non authenticated user can not comment to q/a' do
      it 'do not save to the comment db' do
        expect do
          post :create, question_id: question.id, user_id: user.id, comment: {body: 'new comment'}
        end.to_not change(Comment, :count)
      end
    end
  end
end
