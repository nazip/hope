require 'rails_helper'

describe AnswerPolicy do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:other_question) { create(:question, user: other_user) }
  let(:answer) { create(:answer, question: question, user: user) }

  subject { described_class }

  [:new?, :create?].each do |action|
    permissions action do
      it "authorized user can #{action} answer" do
        expect(subject).to permit(user, Answer.new(question: question, user: user))
      end
      it "non authorized user can not #{action} answer" do
        expect(subject).to_not permit(nil, Answer.new)
      end
    end
  end

  [:destroy?, :update?].each do |action|
    permissions action do
      it "owner can #{action} his answer" do
        expect(subject).to permit(user, answer)
      end
      it "user can not #{action} the answer owned by other user" do
        expect(subject).to_not permit(user, Answer.create(question: question, user: other_user))
      end
    end
  end

  permissions :best? do
    it 'authorized user can set best answer for his question' do
      expect(subject).to permit(user, Answer.create(question: question, user: other_user))
    end
    it 'authorized user can not set best answer for question owned by other user' do
      expect(subject).to_not permit(user, Answer.create(question: other_question, user: user))
    end
    it 'not authorized user can not set best answer' do
      expect(subject).to_not permit(nil, answer)
    end
  end
end
