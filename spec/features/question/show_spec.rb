require 'rails_helper'

feature 'User can browse question with answers' do
  scenario 'User visit page with all questions' do
    question = create(:question)
    answers = create_list(:answer, 3, question: question)
    
    visit question_path(question)

    expect(page).to have_content('Answer Text', count: 3)
  end
end
