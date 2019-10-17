require 'sphinx_helper'

feature 'User can find resource information' do

  describe "Search function" do
    given(:user) { create(:user) }
    given(:other_user) { create(:user) }
    given!(:question) { create(:question, title: 'first q', user: user) }
    given!(:double_question) { create(:question, title: 'last q', user: user) }
    given!(:answer) { create(:answer, body: 'first a body', question: question, user: user) }
    given!(:double_answer) { create(:answer, body: 'last a body', question: question, user: user) }
    given!(:comment_of_question) { create(:comment, body: 'q comment', commentable: question, user: user) }
    given!(:comment_of_answer) { create(:comment, body: 'a comment', commentable: answer, user: user) }

    scenario 'Find Question with Query', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Query', with: question.title
        select 'Questions', from: 'category'
        click_on 'Search'

        expect(page).to have_link question.title
        expect(page).to_not have_link double_question.title

        expect(page).to_not have_link answer.body
        expect(page).to_not have_link comment_of_question.body
        expect(page).to_not have_link comment_of_answer.body
        expect(page).to_not have_content user.email
      end
    end

    scenario 'Find Answer with Query', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Query', with: answer.body
        select 'Answers', from: 'category'
        click_on 'Search'

        expect(page).to have_link answer.body
        expect(page).to_not have_link double_answer.body

        expect(page).to_not have_link question.title
        expect(page).to_not have_link comment_of_question.body
        expect(page).to_not have_link comment_of_answer.body
        expect(page).to_not have_content user.email
      end
    end

    scenario 'Find User with Query', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Query', with: user.email
        select 'Users', from: 'category'
        click_on 'Search'

        expect(page).to have_content user.email
        expect(page).to_not have_content other_user.email

        expect(page).to_not have_link answer.body
        expect(page).to_not have_link question.title
        expect(page).to_not have_link comment_of_question.body
        expect(page).to_not have_link comment_of_answer.body
      end
    end

    scenario 'Find Comment with Query', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Query', with: comment_of_question.body
        select 'Comments', from: 'category'
        click_on 'Search'

        expect(page).to have_link comment_of_question.body
        expect(page).to_not have_link comment_of_answer.body

        expect(page).to_not have_content user.email
        expect(page).to_not have_link answer.body
        expect(page).to_not have_link question.title
      end
    end

    scenario 'Show all resources from all categories', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        expect(page).to have_button 'Search'
        click_on 'Search'
        expect(page).to have_link question.title
        expect(page).to have_link answer.body
        expect(page).to have_link comment_of_question.body
        expect(page).to have_link comment_of_answer.body
        expect(page).to have_content user.email
      end
    end

    scenario 'Not found resource', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Query', with: 'Something else'
        click_on 'Search'
        expect(page).to have_content "Results for Something else was not found"
      end
    end

    scenario 'Search from all with param', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Query', with: question.title
        click_on 'Search'
        expect(page).to have_link question.title
        expect(page).to_not have_link answer.body
        expect(page).to_not have_link comment_of_question.body
        expect(page).to_not have_link comment_of_answer.body
        expect(page).to_not have_content user.email
      end
    end

    scenario 'Question category', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        select 'Questions', from: 'category'
        click_on 'Search'
        expect(page).to have_link question.title
        expect(page).to_not have_link answer.body
        expect(page).to_not have_link comment_of_question.body
        expect(page).to_not have_link comment_of_answer.body
        expect(page).to_not have_content user.email
      end
    end

    scenario 'Answer category', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        select 'Answers', from: 'category'
        click_on 'Search'
        expect(page).to_not have_link question.title
        expect(page).to have_link answer.body
        expect(page).to_not have_link comment_of_question.body
        expect(page).to_not have_link comment_of_answer.body
        expect(page).to_not have_content user.email
      end
    end

    scenario 'User category', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        select 'Users', from: 'category'
        click_on 'Search'
        expect(page).to_not have_link question.title
        expect(page).to_not have_link answer.body
        expect(page).to_not have_link comment_of_question.body
        expect(page).to_not have_link comment_of_answer.body
        expect(page).to have_content user.email
      end
    end

    scenario 'Comment category', js: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        select 'Comments', from: 'category'
        click_on 'Search'
        expect(page).to_not have_link question.title
        expect(page).to_not have_link answer.body
        expect(page).to have_link comment_of_question.body
        expect(page).to have_link comment_of_answer.body
        expect(page).to_not have_content user.email
      end
    end
  end
end
