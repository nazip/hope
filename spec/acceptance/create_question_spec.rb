require 'rails_helper'

feature 'create question', %q(
  user can create the question
) do
  given(:user) { create(:user) }

  scenario 'authenticated user can create the question' do
    sign_in(user)
    create_question
    expect(page).to have_content 'body text'
  end

  scenario 'non authenticated user can NOT create the question' do
    visit questions_path
    click_on 'Создать вопрос'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
