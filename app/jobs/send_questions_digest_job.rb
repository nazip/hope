class SendQuestionsDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.find_each.each do |user|
      SendQuestionsDigest.send_email(user, Question.today_created).deliver_later
    end
  end
end
