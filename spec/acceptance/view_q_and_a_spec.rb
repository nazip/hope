require 'rails_helper'

feature 'view list of question and answer', %q(
  any user can view list of questions and answers
) do
  given!(:user) { create(:user) }
  given!(:answer) { create(:answer, body: 'answer1', question: create(:question, title: 'First question')) }
  given!(:answer1) { create(:answer, body: 'answer2', question: create(:question, title: 'Second question')) }

  scenario 'user can view list of questions and answers' do
    visit questions_path
    expect(page).to have_content 'answer1'
    expect(page).to have_content 'answer2'
    expect(page).to have_content 'First question'
    expect(page).to have_content 'Second question'
   end
end
