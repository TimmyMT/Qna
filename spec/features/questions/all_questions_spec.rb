require 'rails_helper'

feature 'User can watch questions', %q{
  User wants to see all questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Show question' do
    visit root_path
    click_on 'Questions'
    expect(page).to have_content 'All questions'
  end

end
