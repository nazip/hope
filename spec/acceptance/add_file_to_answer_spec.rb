require_relative 'acceptance_helper'

feature 'add files to answer', %q(
  to show answer
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user can attach the files to the answer', js: true do
    fill_in 'answer[body]', with: 'text text text'
    click_on 'add attachment'
    click_on 'add attachment'
    all('.nested-fields').each do |a|
      a.attach_file  'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Создать'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    end
  end
end
