require 'rails_helper'

feature 'User can delete link from question', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable_id: question.id, linkable_type: question.class.to_s) }

  scenario 'author of question deleted link', js: true do
    sign_in(user)
    visit question_path(question)

    within ".question_#{question.id}" do
      expect(page).to have_link link.name
      click_on 'delete link'
      expect(page).to_not have_link link.name
    end
  end

  scenario 'wrong user tries to delete link', js: true do
    sign_in(wrong_user)
    visit question_path(question)

    within ".question_#{question.id}" do
      expect(page).to have_link link.name
      expect(page).to_not have_link 'delete link'
    end
  end

  scenario 'guest tries to delete link', js: true do
    visit question_path(question)

    within ".question_#{question.id}" do
      expect(page).to have_link link.name
      expect(page).to_not have_link 'delete link'
    end
  end

end
