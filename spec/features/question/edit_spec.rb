require 'rails_helper'

feature 'User can edit question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user tryes to edit' do
    scenario 'his question', js: true do
      sign_in(question.user)
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'his answer with errors', js: true do
      sign_in(question.user)
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'
        
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'his question adding files', js: true do
      sign_in(question.user)
      visit question_path(question)

      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      click_on 'Edit question'

      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_selector 'textarea'
      end
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
