require 'rails_helper'

feature 'User can edit his answer', %q{
  description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Guest can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authorized user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Update Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit answer with attached file', js: true do
      within ".answer_#{answer.id}" do
        click_on 'Edit answer'

        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Update Answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with errors', js: true do
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Update Answer'
      end

      expect(page).to have_content "Body can't be blank"
    end

  end

  scenario 'tries to edit other users question', js: true do
    sign_in(wrong_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

end
