require 'rails_helper'

feature 'User can create answer' do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      user = create(:user)
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'Answer text'
      click_on 'Answer'

      expect(page).to have_content 'Your answer succesfully created.'
      expect(page).to have_content 'MyString'
      expect(page).to have_content 'MyText'
      expect(page).to have_content 'Answer text'
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tryes to answers the question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
