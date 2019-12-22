require 'rails_helper'

feature 'User can delete links from answer' do
  given(:answer) { create(:answer, :with_link) }

  scenario 'User deletes links when edits answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    expect(page).to have_link 'Google', href: 'https://google.com'

    within '.answers' do
      click_on 'Edit'
      click_on 'Delete link'
      click_on 'Save'
    end

    expect(page).to_not have_link 'Google', href: 'https://google.com'
  end
end
