require_relative 'acceptance_helper'

feature 'user autorization', %q(
  to authorizate the user using facebook or twitter
) do

  describe "twitter authorizate" do
    it "can sign in user with Twitter account" do
      visit user_session_path
      expect(page).to have_content("Sign in with Twitter")
      mock_auth_hash
      click_link "Sign in with Twitter"

      expect(page).to have_content("Successfully authenticated from twitter account")  # user name
      expect(page).to have_content("Выход из сессии")
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      visit user_session_path
      expect(page).to have_content("Sign in with Twitter")
      click_link "Sign in with Twitter"
      expect(page).to have_content('Could not authenticate you from Twitter')
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

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit user_session_path
      expect(page).to have_content("Sign in with Facebook")
      click_link "Sign in with Facebook"
      expect(page).to have_content('Could not authenticate you from Facebook')
    end
  end
end