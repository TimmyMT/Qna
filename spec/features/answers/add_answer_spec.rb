require 'rails_helper'

feature 'User can create answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'User create answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'first answer'
    click_on 'Create Answer'
    within '.answers' do
      expect(page).to have_content 'first answer'
    end
  end

  scenario 'Guest tries add answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Create Answer'
  end
end
