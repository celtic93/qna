require 'rails_helper'
require "pry"

feature 'User can edit answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user tryes to edit' do
    scenario 'his answer', js: true do
      sign_in(answer.user)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'his answer with errors', js: true do
      sign_in(answer.user)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'
        
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "someone else's answer" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user tryes to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
