require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

  describe 'GET #create' do
    let!(:oauth) { OmniAuth::AuthHash.new({ 'provider' => 'twiter',
                                            'uid' => '123545',
                                            'info' => {"email"=> nil}
                                            }) }
    before do
      session['oauth'] = oauth
      @request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    end

    context 'user exist' do
      let!(:user) { create :user }

      it 'create the new Authorization' do
        expect { post :create, user: {email: user.email } }.to change(Authorization, :count).by(1)
      end
      it 'do not create the new user' do
        expect { post :create, user: {email: user.email } }.to_not change(User, :count)
      end
      it 'do not send email' do
        expect do
          post :create, user: {email: user.email }
        end.to_not change(ActionMailer::Base.deliveries, :count)
      end
    end

    context 'user does not exist' do
      it 'create the new Authorization' do
        expect { post :create, user: {email: 'other@email.ru' } }.to change(Authorization, :count).by(1)
      end
      it 'create new user' do
        expect { post :create, user: {email: 'other@email.ru' } }.to change(User, :count).by(1)
      end
      it 'send email' do
        expect do
          post :create, user: {email: 'other@email.ru' }
        end.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
end
