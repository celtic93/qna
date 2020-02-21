require 'sphinx_helper'

feature 'User can search', sphinx: true, js: true do

  given!(:user) { create(:user, email: 'user-test@test.com') }
  given!(:question) { create(:question, body: 'question-test') }
  given!(:answer) { create(:answer, body: 'answer-test') }
  given!(:comment) { create(:comment, body: 'comment-test', commentable: question) }
  describe 'User can search in specified resource' do

    before { visit root_path }

    Services::Searching::SCOPES.each do |scope|
      scenario "#{scope} search" do
        other_resources = Services::Searching::SCOPES.select{|other| other != scope}
        ThinkingSphinx::Test.run do
          within '.search-form' do
            fill_in 'search_query', with: 'test'
            select scope, from: 'search_scope'
            click_on 'Search'
          end

          expect(page).to have_content "Search results for test:"
          within '.search-results' do
            expect(page).to have_content "#{scope.downcase}-test"

            other_resources.each do |other|
              expect(page).to_not have_content "#{other.downcase}-test"
            end
          end
        end
      end
    end

    scenario 'Search entire site' do
      ThinkingSphinx::Test.run do
        within '.search-form' do
          fill_in 'search_query', with: 'test'
          click_on 'Search'
        end

        expect(page).to have_content "Search results for test:"
        within '.search-results' do
          expect(page).to have_content question.body
          expect(page).to have_content answer.body
          expect(page).to have_content comment.body
          expect(page).to have_content user.email
        end
      end
    end

    scenario 'Search unexisted word' do
      ThinkingSphinx::Test.run do
        within '.search-form' do
          select 'Everywhere', from: 'search_scope'
          fill_in 'search_query', with: 'other'
          click_on 'Search'
        end

        expect(page).to have_content "Search results for other:"
        within '.search-results' do
          expect(page).to have_content 'Nothing was found'
        end
      end
    end
  end
end
