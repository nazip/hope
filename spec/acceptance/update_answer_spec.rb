require_relative 'acceptance_helper'

feature 'update answer', %q(
  to fix the mistake
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:user1) { create(:user) }
  given!(:answer1) { create(:answer, question: question, user: user1) }

  describe 'non authenticated user' do
    before do
      visit questions_path(question)
    end

    scenario 'user can not edit answer', js: true do
      within ".answer-#{answer.id}" do
        expect(page).to_not have_link 'Редактировать ответ'
      end
    end
  end

  describe 'authenticated user' do
    before do
      sign_in(user)
      visit questions_path(question)
    end

    scenario 'can edit his answer', js: true do
      within ".answer-#{answer.id}" do
        click_on 'Редактировать ответ'
        fill_in 'answer[body]', with: 'updated answer'
        click_on 'Сохранить'

        expect(page).to have_content 'updated answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'can not edit an answer owned by other user', js: true do
      click_on 'Выход из сессии'
      sign_in user1
      visit questions_path(question)

      within ".answer-#{answer.id}" do
        expect(page).to_not have_link 'Редактировать ответ'
      end
      within ".answer-#{answer1.id}" do
        expect(page).to have_link 'Редактировать ответ'
      end
    end
  end
end
