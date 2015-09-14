class SendAnswerToSubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    Subscription.where(subscriptionable: answer.question).each do |subscription|
      SendAnswer.send_email(subscription.subscriptionable.user, answer).deliver_later
    end
  end
end
