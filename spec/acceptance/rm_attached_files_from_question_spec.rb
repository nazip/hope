require_relative 'acceptance_helper'

feature 'remove the attached files from question', %q(
  to delete the attached files
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment_question) { create(:attachment, attachable: question) }
  given!(:user1) { create(:user) }

  describe 'unsigned user' do
    scenario 'can not delete the attached the files' do
      visit questions_path
      expect(page).to_not have_link 'delete rails_helper.rb'
    end
  end

  describe 'signed user' do
    background do
      visit questions_path
    end

    scenario 'can delete his attached file', js: true do
      sign_in(user)
      expect(page).to have_link 'rails_helper.rb'
      click_on "delete rails_helper.rb"
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'can not delete attached files owned by other user', js: true do
      sign_in(user1)
      expect(page).to_not have_link 'delete rails_helper.rb'
    end
  end
end
