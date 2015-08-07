require 'rails_helper'

feature 'sing_in', %q(
  to ask the question, the
  user must sign in
) do
  given(:user) { create(:user) }

  scenario 'existing user may sign in' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'non existing user can not sign in' do
    User.create(email: 'abc@test.ru', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'dfg@test.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end
