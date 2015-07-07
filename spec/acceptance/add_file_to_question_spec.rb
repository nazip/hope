require_relative 'acceptance_helper'

feature 'add files to question', %q(
  to show question
) do
  given!(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'user can attach the files to the question', js: true do
    fill_in 'question[title]', with: 'Test question'
    fill_in 'question[body]', with: 'text text text'
    click_on 'add attachment'
    click_on 'add attachment'
    all('.nested-fields').each do |a|
      a.attach_file  'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Создать вопрос'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
  end
end
