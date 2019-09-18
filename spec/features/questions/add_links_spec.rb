require 'rails_helper'

feature 'User can add links to question', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'http://google.com' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Q body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Save'

    expect(page).to have_link 'My gist', href: gist_url
  end

end
