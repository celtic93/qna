require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/celtic93/c30f65926746100a74f911ade581199d' }
  given(:google_url) { 'https://google.com' }
  given(:answer) { create(:answer) }

  describe 'User when asks answer' do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'Answer text'
      fill_in 'Link name', with: 'My gist'
    end

    scenario 'adds links', js: true do
      expect(page).to_not have_link 'Google', href: google_url
      
      fill_in 'Url', with: gist_url

      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'adds link with errors', js: true do
      fill_in 'Url', with: 'gist'

      click_on 'Answer'

      expect(page).to_not have_link 'My gist'
      expect(page).to have_content 'Links url is not a valid URL'
    end
  end

  describe 'User when edits answer' do
    background do
      sign_in(answer.user)
      visit question_path(answer.question)

      click_on 'Edit'

      within '.answer' do
        click_on 'Add link'
        
        fill_in 'Link name', with: 'My gist'
      end
    end

    scenario 'adds links', js: true do
      expect(page).to_not have_link 'Google', href: google_url

      within '.answer' do
        fill_in 'Url', with: gist_url

        click_on 'Add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'Google'
          fill_in 'Url', with: google_url
        end

        click_on 'Save'

        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'adds links with errors', js: true do
      within '.answer' do
        fill_in 'Url', with: 'gist'

        click_on 'Save'
      end

      expect(page).to_not have_link 'My gist'
      expect(page).to have_content 'Links url is not a valid URL'
    end
  end
end
