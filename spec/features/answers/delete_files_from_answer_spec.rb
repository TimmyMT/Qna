require 'rails_helper'

feature 'User can delete files from answer', %q{
  description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Answer with file', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'New body answer'

      attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Create Answer'
    end

    scenario 'authorized user delete file from answer', js: true do
      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'delete file'
        click_on 'delete file'
      end

      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'worng user tries delete file from answer', js: true do
      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'delete file'
      end

      click_on 'Sign out'
      sign_in(wrong_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to_not have_link 'delete file'
      end
    end

    scenario 'guest tries delete file from answer', js: true do
      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'delete file'
      end

      click_on 'Sign out'
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to_not have_link 'delete file'
      end
    end

  end
end
