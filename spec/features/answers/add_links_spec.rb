require 'rails_helper'

feature 'User can add links to answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:new_url) { 'http://google.com' }
  given(:incorrect_url) { 'google.com' }
  given(:gist_url) { 'https://gist.github.com/TimmyMT/fecb0d211eeaa8ab7409e0ddb13899c6' }

  describe 'User adds link when asks question' do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Add answer'

      fill_in 'Body', with: 'A body'

      fill_in 'Link name', with: 'new link'
    end

    scenario 'valid link', js: true do
      fill_in 'Url', with: new_url

      click_on 'Create Answer'

      within '.answers' do
        expect(page).to have_link 'new link', href: new_url
      end
    end

    scenario 'gist link', js: true do
      fill_in 'Url', with: gist_url

      click_on 'Create Answer'

      within '.answers' do
        expect(page).to have_selector('.gist-link')
      end
    end

    scenario 'incorrect link', js: true do
      fill_in 'Url', with: incorrect_url

      click_on 'Create Answer'

      expect(page).to have_content 'Links url is invalid'
    end
  end

end
