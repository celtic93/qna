require 'rails_helper'

feature 'User can browse all his awards' do
  let!(:user) { create(:user, :with_awards)}
  let(:question1) { user.awards[0].question }
  let(:question2) { user.awards[1].question }
  let(:image_name1) { question1.award.image.filename.to_s }
  let(:image_name2) { question2.award.image.filename.to_s }

  scenario 'User visit page with all his awards' do
    sign_in(user)
    visit awards_path

    within "#award-#{question1.award.id}" do
      expect(page).to have_content question1.title
      expect(page).to have_content question1.award.title
      expect(page.find('#award-image')['src']).to have_content image_name1
    end

    within "#award-#{question1.award.id}" do
      expect(page).to have_content question2.title
      expect(page).to have_content question2.award.title
      expect(page.find('#award-image')['src']).to have_content image_name2
    end
  end
end
