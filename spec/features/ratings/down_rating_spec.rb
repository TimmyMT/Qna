require 'rails_helper'

feature 'User can down rating of object', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authorized user make down rating', js: true do
    sign_in(wrong_user)
    visit question_path(question)

    within ".rating_#{question.rating.id}" do
      expect(page).to have_content "0"
    end

    within ".change-rating_#{question.rating.id}" do
      expect(page).to have_link "-"
      click_on "-"
    end

    within ".rating_#{question.rating.id}" do
      expect(page).to have_content "-1"
    end
  end

  scenario 'Author cant change rating for his object' do
    sign_in(user)
    visit question_path(question)

    within ".rating_#{question.rating.id}" do
      expect(page).to have_content "0"
    end

    within ".change-rating_#{question.rating.id}" do
      expect(page).to_not have_link "-"
    end
  end

  scenario 'Guest cant change rating for object' do
    visit question_path(question)

    within ".rating_#{question.rating.id}" do
      expect(page).to have_content "0"
    end

    within ".change-rating_#{question.rating.id}" do
      expect(page).to_not have_link "-"
    end
  end

end
