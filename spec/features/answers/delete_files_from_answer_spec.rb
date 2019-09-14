require 'rails_helper'

feature 'User can delete files from answer', %q{
  description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Answer with file', js: true do
    background do
      FactoryBot.create(:answer, :with_attachment, question: question, user: user)
    end

    scenario 'author delete file from answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'delete file'
        click_on 'delete file'
      end

      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'worng user tries delete file from answer', js: true do
      sign_in(wrong_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to_not have_link 'delete file'
      end
    end

    scenario 'guest tries delete file from answer', js: true do
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to_not have_link 'delete file'
      end
    end

  end
end
