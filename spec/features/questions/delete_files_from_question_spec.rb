require 'rails_helper'

feature 'User can delete files from question', %q{
  description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }

  describe 'Question with file', js: true do
    background do
      @question = FactoryBot.create(:question, :with_attachment, user: user)
    end

    scenario 'authorized user delete file from question', js: true do
      sign_in(user)
      visit question_path(@question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'delete file'

      click_on 'delete file'

      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'worng user tries delete file from question', js: true do
      sign_in(wrong_user)
      visit question_path(@question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'delete file'
    end

    scenario 'guest tries delete file from question', js: true do
      visit question_path(@question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'delete file'
    end

  end
end
