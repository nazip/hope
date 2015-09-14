require_relative 'acceptance_helper'

feature 'subscribeable', %q(
  to subscribe to question
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'autenticated user' do
    context 'can subscribe' do
      background do
        sign_in(user)
        visit questions_path
      end

      scenario 'to question', js: true do
        within ".question-#{question.id}-subscribe" do
          click_on 'Subscribe'
          expect(page).to_not have_content 'Subscribe'
          expect(page).to have_content 'Unsubscribe'
          click_on 'Unsubscribe'
          expect(page).to_not have_content 'Unsubscribe'
          expect(page).to have_content 'Subscribe'
        end
      end
    end
  end

  describe 'non autenticated user' do
    scenario "do not see the link 'subsribe or unsubscribe '", js: true do
      visit questions_path
      expect(page).to_not have_content 'Subscribet'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end
end
