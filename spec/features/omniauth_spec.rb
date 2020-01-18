require 'rails_helper'

feature 'Vkontakte Authentication' do
  given(:user) { create(:user) }
  given(:new_user) { create(:user, confirmed_at: nil) }
  given(:auth) { create(:authorization, :vkontakte, user: user) }

  context 'user already have vk auth' do
    scenario 'can sign in by vk' do
      auth_with :vkontakte, auth.user.email
      visit new_user_session_path

      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account'
    end
  end

  context 'user not have vk auth yet' do
    context 'oauth hash without email' do
      scenario 'can sign in by vk after confirm email' do
        auth_with :vkontakte
        visit new_user_session_path

        click_on 'Sign in with Vkontakte'
        fill_in 'Email', with: new_user.email
        click_on 'Continue'

        open_email(new_user.email)
        current_email.click_link 'Confirm my account'

        expect(page).to have_content 'Email confirmed'
      end
    end
  end
end
