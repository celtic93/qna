require 'rails_helper'

feature 'User can vote for question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:vote) { create(:vote, votable: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content 'Rating: 0'
      expect(page).to have_link 'Love it!'
      expect(page).to have_link 'Hate it!'
    end

    scenario 'votes for question', js: true do
      click_on 'Love it!'

      expect(page).to have_content 'Rating: 1'
      expect(page).to have_content 'You voted'
      expect(page).to_not have_link 'Love it!'
      expect(page).to_not have_link 'Hate it!'
    end

    scenario 'votes against question', js: true do
      click_on 'Hate it!'

      expect(page).to have_content 'Rating: -1'
      expect(page).to have_content 'You voted'
      expect(page).to_not have_link 'Love it!'
      expect(page).to_not have_link 'Hate it!'
    end
  end

  scenario 're-votes', js: true do
    sign_in(vote.user)
    visit question_path(question)

    expect(page).to have_content 'Rating: 1'
    expect(page).to have_content 'You voted'
    expect(page).to_not have_link 'Love it!'
    expect(page).to_not have_link 'Hate it!'
    expect(page).to have_link 'Revote'

    click_on 'Revote'

    expect(page).to have_content 'Rating: 0'
    expect(page).to have_link 'Love it!'
    expect(page).to have_link 'Hate it!'
  end

  scenario 'Author of question tryes to vote' do
    sign_in(question.user)
    visit question_path(question)

    expect(page).to_not have_link 'Love it!'
    expect(page).to_not have_link 'Hate it!'
  end

  scenario 'Unauthenticated user tryes to vote' do
    visit question_path(question)

    expect(page).to_not have_link 'Love it!'
    expect(page).to_not have_link 'Hate it!'
  end
end
