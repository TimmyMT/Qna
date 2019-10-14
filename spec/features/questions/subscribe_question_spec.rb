require 'rails_helper'

feature 'subscribe to a question' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question, user: other_user) }

  before { sign_in(user) }

  scenario 'User can subscribe to a question' do
    visit question_path(other_question)
    click_on 'Sub'
    expect(page).to have_content 'Sub success'
    expect(page).to_not have_link 'Sub'
    expect(page).to have_link 'Unsub'
  end

  scenario 'User can unsubscribe from question' do
    visit question_path(other_question)
    click_on 'Sub'
    expect(page).to have_link 'Unsub'
    click_on 'Unsub'
    expect(page).to have_content 'Unsub success'
    expect(page).to have_link 'Sub'
    expect(page).to_not have_link 'Unsub'
  end

  scenario 'User can unsubscribe from his question' do
    visit question_path(question)
    click_on 'Unsub'
    expect(page).to have_content 'Unsub success'
    expect(page).to have_link 'Sub'
    expect(page).to_not have_link 'Unsub'
  end
end
