require_relative 'acceptance_helper'

feature 'update best answer', %q(
  to change the best answer for question
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: question, user: user) }
  given!(:user1) { create(:user) }
  given!(:answer1) { create(:answer, question: question, user: user1) }

  describe 'non authenticated user' do
    before do
      visit questions_path
    end

    scenario 'can not check/uncheck an answer', js: true do
      within ".answer-#{answer.id}" do
        expect(page).to_not have_link 'Пометить как лучший'
        expect(page).to_not have_link 'Убрать метку лучшего ответа'
      end
    end
  end

  describe 'authenticated user' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'question owner can check and uncheck an answer', js: true do
      within ".answer-#{answer.id}" do
        click_on 'Пометить как лучший'
        expect(page).to_not have_link 'Пометить как лучший'
        expect(page).to have_link 'Убрать метку лучшего ответа'
        click_on 'Убрать метку лучшего ответа'
        expect(page).to have_link 'Пометить как лучший'
        expect(page).to_not have_link 'Убрать метку лучшего ответа'
      end
    end

    scenario 'can check one best answer only', js: true do
      within ".answer-#{answer.id}" do
        click_on 'Пометить как лучший'
        expect(page).to have_link 'Убрать метку лучшего ответа'
        expect(page).to_not have_link 'Пометить как лучший'
      end
      within ".answer-#{second_answer.id}" do
        click_on 'Пометить как лучший'
        expect(page).to have_link 'Убрать метку лучшего ответа'
        expect(page).to_not have_link 'Пометить как лучший'
      end
      within ".answer-#{answer.id}" do
        expect(page).to_not have_link 'Убрать метку лучшего ответа'
        expect(page).to have_link 'Пометить как лучший'
      end
    end

    scenario 'can not check an answer (question owned by other user)', js: true do
      click_on 'Выход из сессии'
      sign_in user1
      visit questions_path

      within ".answer-#{answer1.id}" do
        expect(page).to_not have_link 'Пометить как лучший'
        expect(page).to_not have_link 'Убрать метку лучшего ответа'
      end
    end
  end
end
