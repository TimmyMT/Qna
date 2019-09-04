require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  describe 'Already registered user actions' do

    context 'Unregistered user action' do
      scenario 'tries to sign in' do
        visit new_user_session_path
        fill_in 'Email', with: 'wrong@test.com'
        fill_in 'Password', with: '12345678'
        click_on 'Log in'

        expect(page).to have_content 'Invalid Email or password.'
      end
    end

    context 'Already registered user actions' do
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

  end
end
