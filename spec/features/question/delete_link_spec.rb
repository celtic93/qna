require 'rails_helper'

feature 'User can delete links from question' do
  given(:question) { create(:question, :with_link) }

  scenario 'User deletes links when edits question', js: true do
    sign_in(question.user)
    visit question_path(question)

    expect(page).to have_link 'Google', href: 'https://google.com'

    within '.question' do
      click_on 'Edit question'
      click_on 'Delete link'
      click_on 'Save'
    end

    expect(page).to_not have_link 'Google', href: 'https://google.com'
  end
end
