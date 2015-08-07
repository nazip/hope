require_relative 'acceptance_helper'

feature 'delete answer', %q(
  user can delete his answer only
) do
  given!(:user) { create(:user) }
  given!(:user1) { create(:user) }
  given!(:answer) { create(:answer, body: 'my answer', user: user, question: create(:question, user: user)) }

  scenario 'non authenticated user can NOT delete the answer' do
    visit questions_path
    expect(page).to_not have_content 'Удалить ответ'
  end

  scenario 'authenticated user can delete his answer', js: true do
    sign_in user
    visit questions_path
    expect(page).to have_content 'my answer'
    click_on 'Удалить ответ'
    expect(page).to_not have_content 'my answer'
  end

  scenario 'authenticated user can NOT delete the answer owned by other user', js: true do
    sign_in user1
    visit questions_path
    expect(page).to have_content 'my answer'
    expect(page).to_not have_content 'Удалить ответ'
  end
end
