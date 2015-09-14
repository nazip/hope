require 'rails_helper'

describe SubscriptionPolicy do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  subject { described_class }

  permissions :create? do
    it "authorized user can subscribe to the question's answers" do
      expect(subject).to permit(user, Subscription.new(subscriptionable: question))
    end
    it 'non authorized user can not subscribe to any question' do
      expect(subject).to_not permit(nil, Subscription.new(subscriptionable: question))
    end
  end

  permissions :destroy? do
    it 'authorized user can cancel the subscribe to question' do
      expect(subject).to permit(user, Subscription.new(subscriptionable: question, user: user))
    end
    it 'non authorized user can not cancel the subscribe to any question' do
      expect(subject).to_not permit(nil, Subscription.new(subscriptionable: question, user: user))
    end
  end
end
