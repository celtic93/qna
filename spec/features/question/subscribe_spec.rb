require 'rails_helper'

feature 'User can subscribe to question' do
  given(:author) { create :user }
  given(:user) { create :user }
  given(:question) { create :question, user: author }

  describe 'Authenticated user', js: true do
    scenario 'Question author' do
      sign_in(author)
      visit question_path(question)

      expect(page).to_not have_content 'Subscribe'
      expect(page).to have_content 'Unsubscribe'

      click_on 'Unsubscribe'

      expect(page).to have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'

      click_on 'Subscribe'

      expect(page).to_not have_content 'Subscribe'
      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'Non-author' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'

      click_on 'Subscribe'

      expect(page).to_not have_content 'Subscribe'
      expect(page).to have_content 'Unsubscribe'

      click_on 'Unsubscribe'

      expect(page).to have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end

  scenario 'Unauthenticated user', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
    expect(page).to_not have_content 'Unsubscribe'
  end
end
