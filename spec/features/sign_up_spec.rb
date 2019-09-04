require 'rails_helper'

feature 'User can create account', %q{
  In order to create
  questions or answers
  need to create an account
} do
  describe 'Create account' do
    scenario 'success' do
      visit new_user_registration_path
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Create account'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'failure' do
      visit new_user_registration_path
      fill_in 'Email', with: 'new_user'
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: '123'
      click_on 'Create account'

      expect(page).to_not have_content 'Welcome! You have signed up successfully.'
    end
  end
end


