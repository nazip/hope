class SendQuestionsDigest < ApplicationMailer
  default from: "nazipm@mail.ru"

  def send_email(user, questions)
    @questions = questions
    mail(to: user.email, subject: 'List of new questions')
  end
end
