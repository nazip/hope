require 'rails_helper'

feature 'create answer', %q(
  user can answer to the question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user can create the answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'answer[body]', with: 'new answer'
    click_on 'Создать'

    expect(page).to have_content 'new answer'
  end

  scenario 'non authenticated user can NOT create the answer', js: true do
    visit question_path(question)
    expect(current_path).to eq new_user_session_path
  end
end
