require 'rails_helper'

feature 'sing_up', %q(
  to ask the question or answer
  to the question
) do
  given(:user) { create(:user) }

  scenario 'non existing user can sign up' do
    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'user[email]', with: 'newusers@email.ru'
    fill_in 'user[password]', with: 'newuserspassword'
    fill_in 'user[password_confirmation]', with: 'newuserspassword'
    click_on 'Sign up'
    expect(page).to have_content 'You have signed up successfully.'
  end

  scenario 'existing user can NOT sign up' do
    sign_up(user)
    expect(page).to have_content 'Email has already been taken'
  end
end
