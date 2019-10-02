require 'rails_helper'

feature 'User can add comment to answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: another_user) }

  context "multiple sessions" do
    scenario "add comment to vision for guests", js: true do
      Capybara.using_session('another user') do
        sign_in(another_user)
        visit question_path(question)

        within ".answer_#{answer.id}" do
          expect(page).to have_content "Comments:"
          expect(page).to have_css "#comment_body"
          expect(page).to have_button "Create Comment"
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        within ".answer_#{answer.id}" do
          expect(page).to have_content "Comments:"
          expect(page).to_not have_css "#comment_body"
          expect(page).to_not have_button "Create Comment"
        end

        expect(page).to_not have_content "first comment"
      end

      Capybara.using_session('another user') do
        within ".answer_#{answer.id}" do
          fill_in "write a comment", with: 'first comment'
          click_on "Create Comment"

          within ".commentsAnswer_#{answer.id}" do
            expect(page).to have_content "first comment"
          end
        end
      end

      Capybara.using_session('guest') do
        within ".commentsAnswer_#{answer.id}" do
          expect(page).to have_content "first comment"
        end
      end
    end

    scenario "add comment to vision for other users", js: true do
      Capybara.using_session('another user') do
        sign_in(another_user)
        visit question_path(question)

        within ".answer_#{answer.id}" do
          expect(page).to have_content "Comments:"
          expect(page).to have_css "#comment_body"
          expect(page).to have_button "Create Comment"
        end
      end

      Capybara.using_session('user') do
        sign_in(another_user)
        visit question_path(question)

        within ".answer_#{answer.id}" do
          expect(page).to have_content "Comments:"
          expect(page).to have_css "#comment_body"
          expect(page).to have_button "Create Comment"
        end

        expect(page).to_not have_content "first comment"
      end

      Capybara.using_session('another user') do
        within ".answer_#{answer.id}" do
          fill_in "write a comment", with: 'first comment'
          click_on "Create Comment"

          within ".commentsAnswer_#{answer.id}" do
            expect(page).to have_content "first comment"
          end
        end
      end

      Capybara.using_session('user') do
        within ".commentsAnswer_#{answer.id}" do
          expect(page).to have_content "first comment"
        end

        within ".answer_#{answer.id}" do
          fill_in "write a comment", with: 'second comment'
          click_on "Create Comment"
        end

        within ".commentsAnswer_#{answer.id}" do
          expect(page).to have_content "first comment"
          expect(page).to have_content "second comment"
        end
      end

      Capybara.using_session('another user') do
        within ".commentsAnswer_#{answer.id}" do
          expect(page).to have_content "first comment"
          expect(page).to have_content "second comment"
        end
      end
    end
  end

end
