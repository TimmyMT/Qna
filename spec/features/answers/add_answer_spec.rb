require 'rails_helper'

feature 'User can create answer', %q{
  Description
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authorized user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create answer', js: true do
      click_on 'Add answer'
      fill_in 'Body', with: 'first answer'
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'first answer'
      end
    end

    scenario 'create answer with attached file', js: true do
      click_on 'Add answer'
      fill_in 'Body', with: 'Answer with attached file'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates answer with errors', js: true do
      click_on 'Add answer'
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Guest tries add answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Create Answer'
  end
end
