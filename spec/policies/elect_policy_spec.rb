require 'rails_helper'

describe ElectPolicy do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  subject { described_class }

  permissions :create? do
    it 'authorized user can elect to answer owned by other user' do
      expect(subject).to permit(user, Elect.new(electable: create(:question, user: other_user)))
    end
    it 'authorized user can not elect to his answer' do
      expect(subject).to_not permit(user, Elect.new(electable: question))
    end
    it 'non authorized user can not elect' do
      expect(subject).to_not permit(nil, Elect.new(electable: question))
    end
  end

  permissions :destroy? do
    it 'authorized user can cancel his elect' do
      expect(subject).to permit(user, Elect.new(electable: question, user: user, election: 1))
    end
    it 'authorized user can not cancel elect owned by other user' do
      expect(subject).to_not permit(user, Elect.new(electable: question, user: other_user, election: 1))
    end
    it 'non authorized user can not cancel any elect' do
      expect(subject).to_not permit(nil, Elect.new(electable: question, user: user, election: 1))
    end
  end
end
