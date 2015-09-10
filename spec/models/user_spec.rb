require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :password_confirmation }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:elects) }
  it { should have_many(:authorizations) }

  describe '#elect_for?' do
    let!(:user) { create(:user) }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:elect) { create(:elect, user: user1, electable: question, election: 1) }
    let!(:elect1) { create(:elect, user: user2, electable: question, election: -1) }
    it 'new user can elect ?' do
      expect(user.elect_for?(question, -1)).to eq true
    end
    it 'new user can diselect ?' do
      expect(user.elect_for?(question, 1)).to eq true
    end
    it 'new user can not cancel ?' do
      expect(user.elect_for?(question)).to eq false
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
    let(:auth_twitter) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: nil }) }

    context 'user authorized already (using facebook)' do
      it'return user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end
    context 'user authorized already (using twitter)' do
      it'return user' do
        user.authorizations.create(provider: 'twitter', uid: '123456')
        expect(User.find_for_oauth(auth_twitter)).to eq user
      end
    end

    context 'user does not authorized (facebook)' do
      context 'user already exists' do
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'test@email.ru' }) }
        it 'create user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'save authorization record for user' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq User.where(email: 'test@email.ru').first
        end
      end
    end

    context 'user does not authorized (twitter)' do
      it 'return builded user and authorization record' do
        new_user = User.find_for_oauth(auth_twitter)
        expect(User.find_for_oauth(auth_twitter)).to be_a_new(User)
      end
    end
  end
end
