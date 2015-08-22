require_relative 'acceptance_helper'

feature 'user autorization', %q(
  to authorizate the user using facebook or twitter
) do

  describe "twitter authorizate" do
    background do
      clear_emails
    end

    it "can sign in user with Twitter account" do
      visit user_session_path
      expect(page).to have_content("Sign in with Twitter")
      mock_auth_hash
      click_link "Sign in with Twitter"
      expect(page).to have_content("Sign up")
      fill_in 'user[email]', with: 'test@email.ru'
      click_on "Sign up"
      expect(page).to have_content("confirmation link has been sent")
      open_email('test@email.ru')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content("Your email address has been successfully confirmed")
    end
  end

  describe "facebook authorizate" do
    it "can sign in user with facebook account" do
      visit user_session_path
      expect(page).to have_content("Sign in with Facebook")
      mock_auth_hash
      click_link "Sign in with Facebook"
      expect(page).to have_content("Successfully authenticated from facebook account")  # user name
      expect(page).to have_content("Выход из сессии")
    end
  end
end
