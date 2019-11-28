require 'rails_helper'

feature 'User can choose the best answer of his question' do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:best_answer) { create(:answer, question: question, best: true) }
  given(:user) { create(:user) }

  describe 'Authenticated user tryes to choose' do
    scenario 'the best answer of his question', js: true do
      sign_in(question.user)
      visit question_path(question)

      click_on 'Best answer'
      expect(page).to have_content "It's the best answer"
    end

    scenario "the best answer of someone else's question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Best answer' 
    end

    scenario 'another best answer of his question', js: true do
      sign_in(question.user)
      visit question_path(question)

      within "#answer-#{best_answer.id}" do
        expect(page).to have_content "It's the best answer"
      end

      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Best answer'
        click_on 'Best answer'
      end

      within "#answer-#{best_answer.id}" do
        expect(page).to have_link 'Best answer'
      end

      within "#answer-#{answer.id}" do
        expect(page).to have_content "It's the best answer"
      end
    end
  end

  scenario 'Unauthenticated user tryes to choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end