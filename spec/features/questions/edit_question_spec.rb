require 'rails_helper'

feature 'User can edit his question', %q{
  description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Guest can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authorized user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
      within ".question_#{question.id}" do
        expect(page).to have_link 'Edit question'
        click_on 'Edit question'
      end

      within ".edit_question" do
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New body'
        click_on 'Save'
      end

      within ".question_#{question.id}" do
        expect(page).to have_content 'New title'
      end
    end

    scenario 'edit question with attached file', js: true do
      within ".question_#{question.id}" do
        click_on 'Edit question'
      end

      within ".edit_question" do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      within ".question_#{question.id}" do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his question with errors', js: true do
      within ".question_#{question.id}" do
        expect(page).to have_link 'Edit question'
        click_on 'Edit question'
      end

      within ".edit_question" do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      within ".question_#{question.id}" do
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'wrong user tries to edit question', js: true do
    sign_in(wrong_user)
    visit question_path(question)

    within ".question_#{question.id}" do
      expect(page).to_not have_link 'Edit question'
    end
  end

end
