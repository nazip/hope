module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_up(user)
    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    fill_in 'user[password_confirmation]', with: user.password
    click_on 'Sign up'
  end

  def create_question
    visit questions_path
    click_on 'Создать вопрос'
    fill_in 'question[title]', with: 'title text'
    fill_in 'question[body]', with: 'body text'
    click_on 'Создать вопрос'
    expect(page).to have_content 'Показать все вопросы'
  end
end
