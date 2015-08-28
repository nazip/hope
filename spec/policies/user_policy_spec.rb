require 'rails_helper'

describe UserPolicy do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }

  subject { described_class }


  permissions :me? do
    it 'non authorized user can not get his profile' do
      expect(subject).to_not permit(nil, user)
    end
    it 'authorized user can get his profile ' do
      expect(subject).to permit(user, User.find(access_token.resource_owner_id))
    end
    it 'authorized user can not get the profile of other user' do
      expect(subject).to_not permit(user, User.find(other_access_token.resource_owner_id))
    end
  end

  permissions :index? do
    it 'non authorized user can not get any profile' do
      expect(subject).to_not permit(nil, user)
    end
    it 'authorized user can get all profiles' do
      expect(subject).to permit(user, User.find(access_token.resource_owner_id))
    end
  end
end
