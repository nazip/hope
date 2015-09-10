require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do

    let(:http_req) { '/api/v1/profiles/me' }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token  }

      it_behaves_like 'should return success'

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

    let(:http_req) { '/api/v1/profiles' }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:other_user) { create(:user) }
      let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it_behaves_like 'should return success'

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
  def do_request(options={})
    get http_req, {format: :json}.merge(options)
  end
end
