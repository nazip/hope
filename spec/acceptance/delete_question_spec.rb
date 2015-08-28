require_relative 'acceptance_helper'

feature 'delete question', %q(
  user can delete his question only
) do
  given!(:user) { create(:user) }
  given!(:user1) { create(:user) }
  given!(:question) { create(:question, body: 'first question', user: user) }

  scenario 'non authenticated user can NOT delete the question' do
    visit questions_path
    expect(page).to_not have_content 'Удалить вопрос'
  end

  scenario 'authenticated user can delete his question' do
    sign_in user
    visit questions_path
    expect(page).to have_content 'first question'
    click_on 'Удалить вопрос'
    expect(page).to_not have_content 'first question'
  end

  scenario 'authenticated user can NOT delete the question owned by other user' do
    sign_in user1
    visit questions_path
    expect(page).to have_content 'first question'
    expect(page).to_not have_content 'Удалить вопрос'
  end
end
