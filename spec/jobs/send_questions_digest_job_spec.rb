require 'rails_helper'

RSpec.describe SendQuestionsDigestJob, type: :job do
  let!(:users) { create_list(:user, 2) }
  let!(:question) { create(:question, user: users.first) }
  it 'send email with the list questions' do
    message_delivery = instance_double(ActionMailer::MessageDelivery)
    expect(SendQuestionsDigest).to receive(:send_email).twice.and_return(message_delivery)
    expect(message_delivery).to receive(:deliver_later).twice
    SendQuestionsDigestJob.perform_now
  end
end
