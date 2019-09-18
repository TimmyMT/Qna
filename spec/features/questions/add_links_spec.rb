require 'rails_helper'

feature 'User can add links to question', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:new_url) { 'http://google.com' }
  given(:incorrect_url) { 'google.com' }

  describe 'User adds link when asks question' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Q body'

      fill_in 'Link name', with: 'new link'
    end

    scenario 'valid link' do
      fill_in 'Url', with: new_url

      click_on 'Save'

      expect(page).to have_link 'new link', href: new_url
    end

    scenario 'incorrect link' do
      fill_in 'Url', with: incorrect_url

      click_on 'Save'

      expect(page).to have_content 'Links url is invalid'
    end
  end

end
