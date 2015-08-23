require 'rails_helper'

describe QuestionPolicy do

  let(:user) { create(:user) }

  subject { described_class }

  permissions :index? do
    it 'any user can view list of question' do
      expect(subject).to permit(User.new, create(:question))
    end
  end

  [:new?, :create?].each do |action|
    permissions action do
      it "authorized user can #{action} question" do
        expect(subject).to permit(user, Question.new)
      end
      it "non authorized user can not #{action} question" do
        expect(subject).to_not permit(nil, Question.new)
      end
    end
  end

  permissions :show? do
    it 'authorized user can see the question page' do
      expect(subject).to permit(user, create(:question, user: user))
    end
    it 'non authorized user can not see the question page' do
      expect(subject).to_not permit(nil, create(:question, user: user))
    end
  end

  [:destroy?, :update?].each do |action|
    permissions action do
      it "owner can #{action} his question" do
        expect(subject).to permit(user, create(:question, user: user))
      end
      it "user can not #{action} the question owned by other user" do
        expect(subject).to_not permit(user, create(:question, user: create(:user)))
      end
    end
  end
end
