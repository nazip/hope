require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

  describe 'GET #create' do
    let!(:oauth) { OmniAuth::AuthHash.new({ 'provider' => 'twiter', 'uid' => '123545', "user"=>{"email"=>"mmm@nnnn.ru"} }) }
    let(:user) { create :user }

    before do
      session['oauth'] = oauth
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context 'user exist' do
      it 'create the new Authorization' do
        expect { post :create, user: {email: [user.email] }}.to change(Authorization, :count).by(1)
      end
    end

    # context 'user exist' do
    #   let!(:user) { create(:user) }

    # end


  end

end
