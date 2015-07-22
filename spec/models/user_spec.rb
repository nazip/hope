require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :password_confirmation }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:elects) }

  let!(:user) { create(:user) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:elect) { create(:elect, user: user1, electable: question, election: 1) }
  let!(:elect1) { create(:elect, user: user2, electable: question, election: -1) }

  describe '#elect_for?' do
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
end
