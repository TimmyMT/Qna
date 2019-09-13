require 'rails_helper'

feature 'User can delete files from question', %q{
  description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }

  describe 'Question with file', js: true do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'New q'
      fill_in 'Body', with: 'New body'

      attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Save'
    end

    scenario 'authorized user delete file from question', js: true do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'delete file'

      click_on 'delete file'

      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'worng user tries delete file from question', js: true do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'delete file'

      click_on 'Sign out'
      sign_in(wrong_user)
      visit questions_path

      expect(page).to have_link 'New q'

      click_on 'New q'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'delete file'
    end

    scenario 'guest tries delete file from question', js: true do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'delete file'

      click_on 'Sign out'
      visit questions_path

      expect(page).to have_link 'New q'

      click_on 'New q'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'delete file'
    end

  end
end
