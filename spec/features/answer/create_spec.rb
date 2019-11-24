require 'rails_helper'

feature 'User can create answer' do
  given(:question) { create(:question) }
  let!(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      fill_in 'Body', with: 'Answer text'
      click_on 'Answer'

      expect(page).to have_content 'Question String'
      expect(page).to have_content 'Question Text'
      expect(page).to have_content 'Answer text'
    end

    scenario 'answers the question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tryes to answers the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Answer'
  end
end
