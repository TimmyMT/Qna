require 'rails_helper'

feature 'User can add comment to question', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context "multiple sessions" do
    scenario "add comment to vision for guests", js: true do
      Capybara.using_session('another user') do
        sign_in(another_user)
        visit question_path(question)

        expect(page).to have_content "Comments:"
        expect(page).to have_css "#comment_body"
        expect(page).to have_button "Create Comment"
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_content "Comments:"
        expect(page).to_not have_css "#comment_body"
        expect(page).to_not have_button "Create Comment"

        expect(page).to_not have_content "first comment"
      end

      Capybara.using_session('another user') do
        fill_in "write a comment", with: 'first comment'
        click_on "Create Comment"

        within ".commentsQuestion_#{question.id}" do
          expect(page).to have_content "first comment"
        end
      end

      Capybara.using_session('guest') do
        within ".commentsQuestion_#{question.id}" do
          expect(page).to have_content "first comment"
        end
      end
    end

    scenario "add comment to vision for other users", js: true do
      Capybara.using_session('another user') do
        sign_in(another_user)
        visit question_path(question)

        expect(page).to have_content "Comments:"
        expect(page).to have_css "#comment_body"
        expect(page).to have_button "Create Comment"
      end

      Capybara.using_session('user') do
        sign_in(another_user)
        visit question_path(question)

        expect(page).to have_content "Comments:"
        expect(page).to have_css "#comment_body"
        expect(page).to have_button "Create Comment"

        expect(page).to_not have_content "first comment"
      end

      Capybara.using_session('another user') do
        fill_in "write a comment", with: 'first comment'
        click_on "Create Comment"

        within ".commentsQuestion_#{question.id}" do
          expect(page).to have_content "first comment"
        end
      end

      Capybara.using_session('user') do
        within ".commentsQuestion_#{question.id}" do
          expect(page).to have_content "first comment"
        end

        fill_in "write a comment", with: 'second comment'
        click_on "Create Comment"

        within ".commentsQuestion_#{question.id}" do
          expect(page).to have_content "first comment"
          expect(page).to have_content "second comment"
        end
      end

      Capybara.using_session('another user') do
        within ".commentsQuestion_#{question.id}" do
          expect(page).to have_content "first comment"
          expect(page).to have_content "second comment"
        end
      end
    end
  end

end
