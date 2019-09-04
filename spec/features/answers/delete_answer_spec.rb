require 'rails_helper'

feature 'User can delete answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'User delete answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_content 'Answers:0'
    click_on 'Delete answer'
    expect(page).to have_content 'Answer successfully deleted'
  end

  scenario 'Wrong user tries delete answer' do
    wrong_user = User.create!(email: 'wrong_user@test.com', password: '123456', password_confirmation: '123456')
    sign_in(wrong_user)
    visit question_path(question)

    expect(page).to_not have_content 'Answers:0'
    click_on 'Delete answer'
    expect(page).to have_content 'Not enough permissions'
  end

  scenario 'Guest tries add answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Answers:0'
    click_on 'Delete answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
