# Preview all emails at http://localhost:3000/rails/mailers/send_questions_digest
class SendQuestionsDigestPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/send_questions_digest/send_email
  def send_email
    SendQuestionsDigest.send_email(User.first, Question.all)
  end

end
