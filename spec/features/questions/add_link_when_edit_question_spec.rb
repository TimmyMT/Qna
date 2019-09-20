require 'rails_helper'

feature 'User can add link when edit question', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable_id: question.id, linkable_type: question.class.to_s) }
  given!(:second_url) { 'http://yandex.ru' }
  given!(:gist_url) { 'https://gist.github.com/TimmyMT/fecb0d211eeaa8ab7409e0ddb13899c6' }

  describe 'Author of question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds link', js: true do
      within ".question_#{question.id}" do
        expect(page).to have_link link.name
        click_on 'Edit question'

        fill_in 'Link name', with: 'yandex.ru'
        fill_in 'Url', with: second_url

        click_on 'Save'

        expect(page).to have_link link.name
        expect(page).to have_link 'yandex.ru'
      end
    end

    scenario 'adds gist-link', js: true do
      within ".question_#{question.id}" do
        expect(page).to have_link link.name
        click_on 'Edit question'

        fill_in 'Link name', with: 'gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'

        expect(page).to have_link link.name
        expect(page).to have_selector("#gist-link_#{Question.last.links.last.id}")
      end
    end
  end

  scenario 'wrong user tries to delete link', js: true do
    sign_in(wrong_user)
    visit question_path(question)

    within ".question_#{question.id}" do
      expect(page).to have_link link.name
      expect(page).to_not have_link 'Edit question'
    end
  end

  scenario 'guest tries to delete link', js: true do
    visit question_path(question)

    within ".question_#{question.id}" do
      expect(page).to have_link link.name
      expect(page).to_not have_link 'Edit question'
    end
  end

end
