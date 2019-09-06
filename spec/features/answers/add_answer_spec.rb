require 'rails_helper'

feature 'User can create answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'User create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'first answer'
    click_on 'Create Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'first answer'
    end
  end

  scenario 'Authenticated user creates answer with errors', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Create Answer'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Guest tries add answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Create Answer'
  end
end
