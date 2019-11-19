require 'rails_helper'

feature 'User can delete answer' do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'User tryes to delete his answer' do
    user = answer.user

    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer succesfully deleted.'
  end

  scenario "User tryes to delete someone else's answer" do
    user = create(:user)

    sign_in(user)
    visit question_path(answer.question)
    click_on 'Delete answer'
    
    expect(page).to have_content "You can't delete someone else's answer"
  end
end
