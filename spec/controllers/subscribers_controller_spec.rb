require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'authenticated user can subscribe to question' do
      before { sign_in user }

      it 'create new subscription record' do
        expect{ post :create, question_id: question, format: :js }.to change(Subscription, :count).by(1)
      end
    end

    context 'authenticated user can not subscribe twice to question' do
      before { sign_in user }
      let!(:subscription) { create(:subscription, subscriptionable: question, user: user) }

      it 'not create new subscription record' do
        expect{ post :create, question_id: question, format: :js }.to_not change(Subscription, :count)
      end
    end

    context 'non authenticated user can not subscribe to question' do
      it 'do not create new subscribe record' do
        expect{ post :create, question_id: question, format: :js }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'GET #destroy' do
    let!(:subscription) { create(:subscription, subscriptionable: question, user: user) }
    let!(:other_user) { create(:user) }

    context 'authenticated user can cancel his subscribe' do
      before { sign_in user }

      it 'delete subscribe record' do
        expect{ delete :destroy, id: question, format: :js }.to change(Subscription, :count).by(-1)
      end
    end
    context 'authenticated user can not cancel the subscribe owned by other user' do
      before { sign_in other_user }

      it 'delete subscribe record' do
        expect{ delete :destroy, id: question, format: :js }.to_not change(Subscription, :count)
      end
    end
    context 'non authenticated user can not cancel any subscribe' do
      it 'do not delete subscribe record' do
        expect{ delete :destroy, id: question, format: :js }.to_not change(Subscription, :count)
      end
    end
  end
end
