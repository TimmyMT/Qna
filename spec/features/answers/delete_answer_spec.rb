require 'rails_helper'

feature 'User can delete answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Not Authorized user can not delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  describe 'Authorized user' do
    scenario 'delete his answer', js: true do

      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content answer.body
        click_on 'Delete answer'
        wait_for_ajax

        expect(page).to_not have_content answer.body
      end
    end

    scenario 'tries to delete other users answer', js: true do
      sign_in(wrong_user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

end
