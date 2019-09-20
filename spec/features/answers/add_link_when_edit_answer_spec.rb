require 'rails_helper'

feature 'User can add link when edit answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable_id: answer.id, linkable_type: answer.class.to_s) }
  given!(:second_url) { 'http://yandex.ru' }
  given!(:gist_url) { 'https://gist.github.com/TimmyMT/fecb0d211eeaa8ab7409e0ddb13899c6' }

  describe 'Author of answer' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'author of answer adds link', js: true do
      within ".answer_#{answer.id}" do
        expect(page).to have_link link.name
        click_on 'Edit answer'

        fill_in 'Link name', with: 'yandex.ru'
        fill_in 'Url', with: second_url

        click_on 'Update Answer'

        expect(page).to have_link link.name
        expect(page).to have_link 'yandex.ru'
      end
    end

    scenario 'author of answer adds gist-link', js: true do
      within ".answer_#{answer.id}" do
        expect(page).to have_link link.name
        click_on 'Edit answer'

        fill_in 'Link name', with: 'gist'
        fill_in 'Url', with: gist_url

        click_on 'Update Answer'

        expect(page).to have_link link.name
        expect(page).to have_selector("#gist-link_#{Answer.last.links.last.id}")
      end
    end
  end

  scenario 'wrong user tries to delete link', js: true do
    sign_in(wrong_user)
    visit question_path(question)

    within ".answer_#{answer.id}" do
      expect(page).to have_link link.name
      expect(page).to_not have_link 'Edit answer'
    end
  end

  scenario 'guest tries to delete link', js: true do
    visit question_path(question)

    within ".answer_#{answer.id}" do
      expect(page).to have_link link.name
      expect(page).to_not have_link 'Edit answer'
    end
  end

end
