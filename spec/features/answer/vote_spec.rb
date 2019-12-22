require 'rails_helper'

feature 'User can vote for answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_link 'Love it!'
        expect(page).to have_link 'Hate it!'
      end
    end

    scenario 'votes for answer', js: true do
      within '.answers' do
        click_on 'Love it!'

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content 'You voted'
        expect(page).to_not have_link 'Love it!'
        expect(page).to_not have_link 'Hate it!'
      end
    end

    scenario 'votes against answer', js: true do
      within '.answers' do
        click_on 'Hate it!'

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content 'You voted'
        expect(page).to_not have_link 'Love it!'
        expect(page).to_not have_link 'Hate it!'
      end
    end
  end

  scenario 're-votes'
  scenario 'Author of answer tryes to vote'
  
  scenario 'Unauthenticated user tryes to vote' do
    visit question_path(question)

    expect(page).to_not have_link 'Love it!'
    expect(page).to_not have_link 'Hate it!'
  end
end
