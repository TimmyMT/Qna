require 'rails_helper'

feature 'User can up rating of object', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authorized user make up rating', js: true do
    sign_in(wrong_user)
    visit question_path(question)

    within ".rating-question_#{question.id}" do
      expect(page).to have_content "0"
    end

    within ".change-rating" do
      expect(page).to have_css "#vote-up-question_#{question.id}"
      click_on "Vote Up"
    end

    within ".rating-question_#{question.id}" do
      expect(page).to have_content "1"
    end
  end

  scenario 'Author cant change rating for his object' do
    sign_in(user)
    visit question_path(question)

    within ".rating-question_#{question.id}" do
      expect(page).to have_content "0"
    end

    within ".change-rating" do
      expect(page).to_not have_css "#vote-up-question_#{question.id}"
    end
  end

  scenario 'Guest cant change rating for object' do
    visit question_path(question)

    within ".rating-question_#{question.id}" do
      expect(page).to have_content "0"
    end

    within ".change-rating" do
      expect(page).to_not have_css "#vote-up-question_#{question.id}"
    end
  end

end
