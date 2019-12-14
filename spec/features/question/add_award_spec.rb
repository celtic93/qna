require 'rails_helper'

feature 'User can add award to question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'User when asks question' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'adds award' do
      fill_in 'Award title', with: 'Award title'
      attach_file 'Award image', "#{Rails.root}/spec/fixtures/award.jpg"

      click_on 'Ask'

      expect(page).to have_content 'The author of the best answer will get Award title award'
    end

    scenario 'adds award with errors', js: true do
      attach_file 'Award image', "#{Rails.root}/spec/fixtures/award.jpg"

      click_on 'Ask'

      expect(page).to have_content "Award title can't be blank"
    end
  end
end
