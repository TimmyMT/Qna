require 'rails_helper'

feature 'User can delete answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'User delete question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete question'
    expect(page).to have_content 'Question successfully deleted'
    expect(page).to have_content 'All questions'
  end

  scenario 'Wrong user tries to delete question' do
    wrong_user = User.create!(email: 'wrong_user@test.com', password: '123456', password_confirmation: '123456')
    sign_in(wrong_user)
    visit question_path(question)

    click_on 'Delete question'
    expect(page).to have_content 'Not enough permissions'
  end

  scenario 'Guest tries delete question' do
    visit question_path(question)

    click_on 'Delete question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
