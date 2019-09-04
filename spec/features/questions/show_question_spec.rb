require 'rails_helper'

feature 'User can watch question', %q{
  User wants to see a question
} do

  given(:user) { create(:user) }

  scenario 'Show question' do
    question = user.questions.create!(title: 'Question show', body: 'Test body')
    question.answers.create!(body: 'first answer', user: user)

    visit root_path
    click_on 'Questions'

    expect(page).to have_content 'All questions'
    expect(page).to have_content('Question show')

    click_on 'Question show'

    expect(page).to have_content('first answer')
  end

end
