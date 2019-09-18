require 'rails_helper'

feature 'User can create question with achievement', %q{
  Description
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:achievement) { create(:achievement, question: question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authorized user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'user taked achievement', js: true do
      within ".answer_#{answer.id}" do
        expect(page).to have_content answer.body
        click_on 'Make it best'
      end
      click_on 'Your achievements'
      expect(page).to have_content achievement.name
    end
  end

end
