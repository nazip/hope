require_relative 'acceptance_helper'

feature 'update question', %q(
  to fix the mistake
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:user1) { create(:user) }
  given!(:question1) { create(:question, user: user1) }

  describe 'non authenticated user' do
    before do
      visit questions_path(question)
    end

    scenario 'user can not edit question', js: true do
      expect(page).to_not have_link 'Редактировать вопрос'
    end
  end

  describe 'authenticated user' do
    before do
      sign_in(user)
      visit questions_path(question)
    end

    scenario 'can edit his question', js: true do
      within ".question-#{question.id}" do
        click_on 'Редактировать вопрос'
        fill_in 'question[body]', with: 'updated question'
        click_on 'Сохранить'

        expect(page).to have_content 'updated question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'can not edit the question owned by other user', js: true do
      click_on 'Выход из сессии'
      sign_in user1
      visit questions_path(question)

      within ".question-#{question.id}" do
        expect(page).to_not have_link 'Редактировать вопрос'
      end
      within ".question-#{question1.id}" do
        expect(page).to have_link 'Редактировать вопрос'
      end
    end
  end
end
