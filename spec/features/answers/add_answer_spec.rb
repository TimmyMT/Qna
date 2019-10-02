require 'rails_helper'

feature 'User can create answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:new_url) { 'http://google.com' }

  describe 'Authorized user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create answer', js: true do
      # click_on 'Add answer'
      fill_in 'Body', with: 'first answer'
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'first answer'
      end
    end

    scenario 'create answer with attached file', js: true do
      # click_on 'Add answer'
      fill_in 'Body', with: 'Answer with attached file'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates answer with errors', js: true do
      # click_on 'Add answer'
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  context "multiple sessions" do
    scenario "add answer to vision for other users", js: true do
      Capybara.using_session('another user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        expect(page).to_not have_css ".card-body"
      end

      Capybara.using_session('another user') do
        fill_in 'Body', with: 'new answer for check actioncable'
        attach_file 'Files', "#{Rails.root}/spec/static/stewart.jpg"
        fill_in 'Link name', with: 'new link'
        fill_in 'Url', with: new_url

        click_on 'Create Answer'

        within ".card-body" do
          expect(page).to have_content 'new answer for check actioncable'
          expect(page).to have_link 'stewart.jpg'
          expect(page).to have_link 'new link', href: new_url
          expect(page).to_not have_link 'Vote up'
          expect(page).to_not have_link 'Vote down'
          expect(page).to have_content 'Votes rating:0'

          expect(page).to_not have_link "Make it best"
          expect(page).to have_content "Comments:"
          expect(page).to have_css "#comment_body"
          expect(page).to have_button "Create Comment"
        end
      end

      Capybara.using_session('user') do
        within ".card-body" do
          expect(page).to have_content 'new answer for check actioncable'
          expect(page).to have_link 'stewart.jpg'
          expect(page).to have_link 'new link', href: new_url
          expect(page).to have_link 'Vote up'
          expect(page).to have_link 'Vote down'
          expect(page).to have_content 'Votes rating:0'

          expect(page).to have_link "Make it best"
          expect(page).to have_content "Comments:"
          expect(page).to have_css "#comment_body"
          expect(page).to have_button "Create Comment"
        end
      end
    end

    scenario "add answer to vision for guests", js: true do
      Capybara.using_session('another user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to_not have_css ".card-body"
      end

      Capybara.using_session('another user') do
        fill_in 'Body', with: 'new answer for check actioncable'
        attach_file 'Files', "#{Rails.root}/spec/static/stewart.jpg"
        fill_in 'Link name', with: 'new link'
        fill_in 'Url', with: new_url

        click_on 'Create Answer'

        within ".card-body" do
          expect(page).to have_content 'new answer for check actioncable'
          expect(page).to have_link 'stewart.jpg'
          expect(page).to have_link 'new link', href: new_url
          expect(page).to_not have_link 'Vote up'
          expect(page).to_not have_link 'Vote down'
          expect(page).to have_content 'Votes rating:0'

          expect(page).to_not have_link "Make it best"
          expect(page).to have_content "Comments:"
          expect(page).to have_css "#comment_body"
          expect(page).to have_button "Create Comment"
        end
      end

      Capybara.using_session('guest') do
        within ".card-body" do
          expect(page).to have_content 'new answer for check actioncable'
          expect(page).to have_link 'stewart.jpg'
          expect(page).to have_link 'new link', href: new_url
          expect(page).to_not have_link 'Vote up'
          expect(page).to_not have_link 'Vote down'
          expect(page).to have_content 'Votes rating:0'

          expect(page).to_not have_link "Make it best"
          expect(page).to have_content "Comments:"
          expect(page).to_not have_css "#comment_body"
          expect(page).to_not have_button "Create Comment"
        end
      end
    end
  end

  scenario 'Guest tries add answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Create Answer'
  end
end
