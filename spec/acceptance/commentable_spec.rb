require_relative 'acceptance_helper'

feature 'commentable', %q(
  to comment to q/a
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'autenticated user' do
    context 'can comment' do
      background do
        sign_in(user)
        visit question_path(id: question)
      end

      scenario 'to question', js: true do
        within ".question-comments-#{question.id}" do
          click_on 'add comment'
          fill_in 'comment[body]', with: 'questions comment'
          click_on 'Сохранить'
          expect(page).to have_content 'questions comment'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'to answer', js: true do
        within ".answer-comments-#{answer.id}" do
          click_on 'add comment'
          fill_in 'comment[body]', with: 'answers comment'
          click_on 'Сохранить'
          expect(page).to have_content 'answers comment'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end
  end

  describe 'non autenticated user' do
    scenario "do not see the link 'add comment link'", js: true do
      visit questions_path
      expect(page).to_not have_content 'add comment'
    end
  end
end
