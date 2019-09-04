require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authorized user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'user asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'user asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'UnAuthorized user tries to ask a question' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'
  end
end
