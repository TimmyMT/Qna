require 'rails_helper'

feature 'User can choose best answer', %q{
  description
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:first_answer) { create(:answer, question: question, user: user) }
  given!(:two_answer) { create(:answer, question: question, user: user) }

  describe 'Authorized user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'choose best answer', js: true do
      within ".answer_#{first_answer.id}" do
        click_on 'Make it best'
      end

      within ".best_answer_of_question" do
        expect(page).to have_content first_answer.body
      end

      within ".answers" do
        expect(page).to_not have_css ".answer_#{first_answer.id}"
      end

      within ".answers" do
        expect(page).to have_css ".answer_#{two_answer.id}"
      end

      within ".answer_#{two_answer.id}" do
        click_on 'Make it best'
      end

      within ".answers" do
        expect(page).to have_css ".answer_#{first_answer.id}"
      end

      within ".answers" do
        expect(page).to_not have_css ".answer_#{two_answer.id}"
      end
    end
  end

end
