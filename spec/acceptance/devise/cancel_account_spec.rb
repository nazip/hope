require 'rails_helper'

feature 'Sign out', %q( for user
) do
  given(:user) { create(:user) }

  scenario 'existing user can sign out' do
    sign_in(user)
    visit questions_path
    expect(page).to have_link('Выход из сессии')
    click_on 'Выход из сессии'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'non existing can NOT sign out' do
    visit questions_path
    expect(page).to_not have_link('Выход из сессии')
  end
end
