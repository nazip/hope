# Preview all emails at http://localhost:3000/rails/mailers/send_answer
class SendAnswerPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/send_annswer/send_email
  def send_email
    SendAnswer.send_email(User.first, Answer.first)
  end
end
