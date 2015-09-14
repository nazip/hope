require 'rails_helper'

RSpec.describe SendAnswerToSubscribersJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:subscription) { create_list(:subscription, 2, user: user, subscriptionable: question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  it 'send answer list to subscriber' do
    message_delivery = instance_double(ActionMailer::MessageDelivery)
    expect(SendAnswer).to receive(:send_email).twice.and_return(message_delivery)
    expect(message_delivery).to receive(:deliver_later).twice
    SendAnswerToSubscribersJob.perform_now(answer)
  end
end
