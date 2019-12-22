require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/celtic93/c30f65926746100a74f911ade581199d' }
  given(:google_url) { 'https://google.com' }
  given!(:question) { create(:question) }

  describe 'User when asks question' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

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

      click_on 'Ask'
      
      expect(page).to have_content 'Ruby Basic question 2'
      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'adds link with errors', js: true do
      fill_in 'Url', with: 'gist'

      click_on 'Ask'

      expect(page).to_not have_link 'My gist'
      expect(page).to have_content 'Links url is not a valid URL'
    end
  end

  describe 'User when edits question' do
    background do
      sign_in(question.user)
      visit question_path(question)

      click_on 'Edit question'
    end

    scenario 'adds links', js: true do
      expect(page).to_not have_link 'Google', href: google_url
      
      within '.question' do
        click_on 'Add link'
        
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'Google'
          fill_in 'Url', with: google_url
        end

        click_on 'Save'

        expect(page).to have_content 'Ruby Basic question 2'
        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'adds link with errors', js: true do
      within '.question' do
        click_on 'Add link'
        
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: 'gist'

        click_on 'Save'
      end

      expect(page).to_not have_link 'My gist'
      expect(page).to have_content 'Links url is not a valid URL'
    end
  end
end
