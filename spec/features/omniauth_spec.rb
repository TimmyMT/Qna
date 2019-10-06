require 'rails_helper'

feature 'User can log in with OAuth' do
  it 'login using Github' do
    visit new_user_session_path
    expect(page).to have_link 'Sign in with GitHub'
    mock_auth_hash(:github, 'user@test.com')
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'

    within '.navbar' do
      expect(page).to have_link 'Sign out'
      expect(page).to_not have_link 'Sign in'
      expect(page).to_not have_link 'Sign up'
      expect(page).to have_content 'user@test.com'
    end
  end

  it 'login using Facebook' do
    visit new_user_session_path
    expect(page).to have_link 'Sign in with Facebook'
    mock_auth_hash(:facebook, 'user@test.com')
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Successfully authenticated from Facebook account.'

    within '.navbar' do
      expect(page).to have_link 'Sign out'
      expect(page).to_not have_link 'Sign in'
      expect(page).to_not have_link 'Sign up'
      expect(page).to have_content 'user@test.com'
    end
  end

  it 'login using GitHub without email' do
    visit new_user_session_path
    expect(page).to have_link 'Sign in with GitHub'
    mock_auth_hash(:github)
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Email was undefinded, but you can sign up your account'

    within '.navbar' do
      expect(page).to_not have_link 'Sign out'
      expect(page).to have_link 'Sign in'
      expect(page).to have_link 'Sign up'
    end
  end

  it 'login using Facebook without email' do
    visit new_user_session_path
    expect(page).to have_link 'Sign in with Facebook'
    mock_auth_hash(:facebook)
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Email was undefinded, but you can sign up your account'

    within '.navbar' do
      expect(page).to_not have_link 'Sign out'
      expect(page).to have_link 'Sign in'
      expect(page).to have_link 'Sign up'
    end
  end
end
