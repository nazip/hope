class SendAnswer < ApplicationMailer
  default from: "nazipm@mail.ru"

  def send_email(user, answer)
    @answer = answer
    mail(to: user.email, subject: 'You have the new answer')
  end
end
