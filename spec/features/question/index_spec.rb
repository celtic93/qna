require 'rails_helper'

feature 'User can browse all questions' do
  scenario 'User visit page with all questions' do
    questions = create_list(:question, 3)
    visit questions_path

    expect(page).to have_content('MyString', count: 3)
  end
end
