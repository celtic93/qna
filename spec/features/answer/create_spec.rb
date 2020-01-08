require 'rails_helper'

feature 'User can create answer' do
  given(:question) { create(:question) }
  let!(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      fill_in 'Body', with: 'Answer text'
      click_on 'Answer'

      expect(page).to have_content 'Question String'
      expect(page).to have_content 'Question Text'
      expect(page).to have_content 'Answer text'
    end

    scenario 'answers the question fith files', js: true do
      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      fill_in 'Body', with: 'Answer text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'answers the question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "answer appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('quest') do
      visit question_path(question)

      expect(page).to_not have_content 'Answer text'
      expect(page).to_not have_link 'spec_helper.rb'
      expect(page).to_not have_link 'Google'
    end

    Capybara.using_session('user') do
      fill_in 'Body', with: 'Answer text'
      attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb"]
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: 'https://google.com'

      click_on 'Answer'

      expect(page).to have_content 'Question String'
      expect(page).to have_content 'Question Text'
      expect(page).to have_content 'Answer text'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'Google', href: 'https://google.com'
    end

    Capybara.using_session('quest') do
      expect(page).to have_content 'Question String'
      expect(page).to have_content 'Question Text'
      expect(page).to have_content 'Answer text'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'Google', href: 'https://google.com'
    end
  end

  scenario 'Unauthenticated user tryes to answers the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Answer'
  end
end
