require 'rails_helper'

feature 'User can delete question' do
  given(:question) { create(:question) }

  scenario 'User tryes to delete his question' do
    user = question.user

    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question succesfully deleted.'
  end

  scenario "User tryes to delete someone else's question" do
    user = create(:user)

    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content "You can't delete someone else's question"
  end
end
