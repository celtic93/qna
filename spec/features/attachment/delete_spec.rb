require 'rails_helper'

feature 'User can delete attached files' do
  given(:question_with_file) { create(:question, :with_file) }
  given(:user) { create(:user) }

  describe 'Authenticated user tryes to delete attached file of', js: true do
    scenario 'his question' do
      sign_in(question_with_file.user)
      visit question_path(question_with_file)
      expect(page).to have_link 'rails_helper.rb'

      click_on 'Remove file'
      expect(page).to_not have_content 'Remove file'
    end

    scenario "someone else's question" do
      sign_in(user)
      visit question_path(question_with_file)

      expect(page).to_not have_link 'Remove file'
    end
  end

  scenario 'Unauthenticated user tryes to delete attached files' do
    visit question_path(question_with_file)

    expect(page).to_not have_link 'Remove file'
  end
end
