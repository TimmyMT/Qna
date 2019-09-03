require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do


  scenario 'Create new account' do
    visit new_user_registration_path
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Create account'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  describe 'Already registered user actions' do
    given(:user) { create(:user) }

    background do
      visit new_user_session_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    scenario 'User tries to sign out' do
      click_on 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
    end

    scenario 'User tries to sign in' do
      # save_and_open_page - для запуска вьюхи
      expect(page).to have_content 'Signed in successfully.'
    end
  end

  scenario 'Unregistered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
