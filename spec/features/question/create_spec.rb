require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a comunity
  As an authenticated user
  I'd like to able to ask the question
} do
  
  given (:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question succesfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with link' do
      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'
      
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with errors', js: true do
      click_on 'Ask'
      save_and_open_page
      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario "question appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      
      visit questions_path
      click_on 'Ask question'
    end

    Capybara.using_session('quest') do
      visit questions_path
      expect(page).to_not have_link 'Test question'
    end

    Capybara.using_session('user') do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question succesfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    Capybara.using_session('quest') do
      expect(page).to have_link 'Test question'
    end
  end

  scenario 'Unauthenticated user tryes to ask a question' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end
end
