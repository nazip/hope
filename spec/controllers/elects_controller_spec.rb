require 'rails_helper'

RSpec.describe ElectsController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'authenticated user can elect to other q/a' do
      before do
        sign_in user1
      end

      it 'save @elect' do
        expect do
          post :create, question_id: question.id, like: 1, user_id: user1.id, format: :json
        end.to change(question.elects, :count).by(1)
      end

      it '@elect has the user_id of the assigned user' do
        post :create, question_id: question.id, like: 1, user_id: user1.id, format: :json
        expect(assigns(:elect).user_id).to eq user1.id
      end

      it '@elect has the value of the election field = 1' do
        post :create, question_id: question.id, like: 1, user_id: user1.id, format: :json
        expect(assigns(:elect).election).to eq 1
      end
    end

    context 'authenticated user can not elect to his q/a' do
      before { sign_in user }

      it 'can not save @elect' do
        expect do
          post :create, question_id: question.id, like: 1, user_id: user.id, format: :json
        end.to_not change(question.elects, :count)
      end
    end

    context 'authenticated user can not elect to other q/a twice' do
      before do
        sign_in user1
        elect = Elect.create(user_id: user1.id, electable_type: 'Question',
                             electable_id: question.id, election: 1)
      end

      it 'do not change the records number' do
        expect do
          post :create, question_id: question.id, like: 1, user_id: user.id, format: :json
        end.to_not change(question.elects, :count)
      end
    end
  end

  describe 'GET #destroy' do
    before do
      @elect = Elect.create(user_id: user.id, electable_type: 'Question',
                           electable_id: question.id, election: 1)
    end

    context 'authenticated user' do
      it 'can delete his record' do
        sign_in user

        expect do
          post :destroy, question_id: question.id, id: @elect.id
        end.to change(question.elects, :count).by(-1)
      end

      it 'can not delete other record' do
        sign_in user1

        expect do
          post :destroy, question_id: question.id, id: @elect.id
        end.to_not change(question.elects, :count)
      end
    end

    context 'non authenticated user' do
      it 'can not delete any record' do
        expect do
          post :destroy, question_id: question.id, id: @elect.id
        end.to_not change(question.elects, :count)
      end
    end
  end
end
