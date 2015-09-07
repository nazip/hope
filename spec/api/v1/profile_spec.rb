require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token  }

      it 'return 200' do
        expect(response).to be_success
      end

      %w(email id updated_at created_at).each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr).to_json).at_path(attr)
        end
      end

      %w(password, encrypted_password).each do |attr|
        it "do not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do

    context 'unauthorized' do
      it 'without token -> return 401' do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end
      it 'invalid token -> return 401' do
        get '/api/v1/profiles', format: :json, access_token: '111'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:other_user) { create(:user) }
      let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'return 200' do
        expect(response).to be_success
      end

      it 'return users except authonticated user' do
        expect(response.body).to be_json_eql(other_user.send('email').to_json).at_path("profiles/0/email")
        expect(response.body).to_not be_json_eql(user.send('email').to_json).at_path("profiles/0/email")
      end

      %w(id email updated_at created_at).each do |attr|
        it "contain other_user's #{attr} " do
          expect(response.body).to be_json_eql(other_user.send(attr).to_json).at_path("profiles/0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "doesn't contain #{attr}" do
          expect(response.body).to_not have_json_path("profiles/0/#{attr}")
        end
      end
    end
  end
end
