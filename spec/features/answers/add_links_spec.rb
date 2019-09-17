require 'rails_helper'

feature 'User can add links to answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/TimmyMT/fecb0d211eeaa8ab7409e0ddb13899c6' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Add answer'

    fill_in 'Body', with: 'A body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

end
