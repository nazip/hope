require_relative 'acceptance_helper'

feature 'election', %q(
  to like some q/a
) do
  given!(:user) { create(:user) }
  given!(:user1) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:elect) { create(:elect, electable_id: question.id, electable_type: 'Question', election: 1, user_id: user.id) }

  describe 'autenticated user' do

    context 'q/a owned by other user' do
      background do
        sign_in(user1)
        visit questions_path
      end

      scenario 'like/dislike/cancel to the q/a', js: true do
        click_on 'like'
        expect(page).to have_content 'Рейтинг: 2'
        click_on 'dislike'
        expect(page).to have_content 'Рейтинг: 0'
        click_on 'cancel'
        expect(page).to have_content 'Рейтинг: 1'
      end
    end

    context 'q/a owned by user' do
      background do
        sign_in(user)
        visit questions_path
      end

      scenario 'CAN NOT like/dislike/cancel to the q/a', js: true do
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
      end
    end
  end

  describe 'non autenticated user' do
    context 'can not like/dislike/cancel to the q/a' do
      background { visit questions_path }

      scenario 'do not see like/dislike links', js: true do
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
      end
    end
  end
end
