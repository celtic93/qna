require 'rails_helper'

feature 'User can create comments' do
  
  given (:user) { create(:user) }
  given (:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'comments a question', js: true do
      within ".comments#question-#{question.id}" do
        fill_in 'Comment', with: 'Comment text'
        click_on 'Comment'

        expect(page).to have_content "Comment text. #{user.email}"
      end
    end

    scenario 'comments a question with errors', js: true do
      within ".comments#question-#{question.id}" do
        click_on 'Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tryes to comment a question' do
    visit question_path(question)
    expect(page).to_not have_button 'Comment'
  end
end
