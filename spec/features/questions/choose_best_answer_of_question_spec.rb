require 'rails_helper'

feature 'User can choose best answer', %q{
  description
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:first_answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: question, user: user) }

  describe 'Authorized user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'choose best answer', js: true do
      within ".answer_#{first_answer.id}" do
        click_on 'Make it best'
        expect(page).to have_css '.best_answer_of_question'
        expect(page).to have_content 'Best answer!'
      end

      within ".answer_#{second_answer.id}" do
        expect(page).to_not have_content 'Best answer!'
        click_on 'Make it best'
        expect(page).to have_css '.best_answer_of_question'
        expect(page).to have_content 'Best answer!'
      end

      within ".answer_#{first_answer.id}" do
        expect(page).to_not have_css '.best_answer_of_question'
        expect(page).to_not have_content 'Best answer!'
      end

      within ".answers" do
        expect(page.body).to match(/answer_#{second_answer.id}.*answer_#{first_answer.id}/)
      end
    end
  end

  describe 'Wrong user' do
    background do
      sign_in(wrong_user)

      visit question_path(question)
    end

    scenario 'tries choose best answer' do
      expect(page).to_not have_link 'Make it best'
    end
  end

  describe 'Guest' do
    background do
      visit question_path(question)
    end

    scenario 'tries choose best answer' do
      expect(page).to_not have_link 'Make it best'
    end
  end

end
