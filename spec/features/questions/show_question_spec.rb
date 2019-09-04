require 'rails_helper'

feature 'User can watch question', %q{
  User wants to see a question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Show question' do
    visit root_path
    click_on 'Questions'
    click_on 'MyString'
    expect(page).to have_content 'Question id'
  end

end
