require 'rails_helper'

feature 'Authorization with OAuth providers' do
  given(:user) { create(:user) }
  given(:new_user) { create(:user, confirmed_at: nil) }
  given(:auth_github) { create(:authorization, :github, user: user) }
  given(:auth_vkontakte) { create(:authorization, :vkontakte, user: user) }

  describe 'Github Authentication' do
    context 'user already have github auth' do
      scenario 'can sign in by github' do
        auth_with(:github, auth_github.user.email)
        visit new_user_session_path

        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Successfully authenticated from Github account'
      end
    end

    context 'user not have github auth yet' do
      context 'oauth hash without email' do
        background do
          auth_with(:github)
          visit new_user_session_path

          click_on 'Sign in with GitHub'
        end

        scenario 'can sign in by github after confirm email' do
          fill_in 'Email', with: new_user.email
          click_on 'Resend confirmation instructions'

          open_email(new_user.email)
          current_email.click_link 'Confirm my account'

          expect(page).to have_content 'Your email address has been successfully confirmed.'
        end

        scenario 'can not sign in by github with invalid email' do
          fill_in 'Email', with: nil
          click_on 'Resend confirmation instructions'

          expect(page).to have_content "Email can't be blank"
        end
      end
    end
  end

  describe 'Vkontakte Authentication' do
    context 'user already have vk auth' do
      scenario 'can sign in by vk' do
        auth_with(:vkontakte, auth_vkontakte.user.email)
        visit new_user_session_path

        click_on 'Sign in with Vkontakte'
        expect(page).to have_content 'Successfully authenticated from Vkontakte account'
      end
    end

    context 'user not have vk auth yet' do
      context 'oauth hash without email' do
        background do
          auth_with(:vkontakte)
          visit new_user_session_path

          click_on 'Sign in with Vkontakte'
        end
        
        scenario 'can sign in by vk after confirm email' do
          fill_in 'Email', with: new_user.email
          click_on 'Resend confirmation instructions'

          open_email(new_user.email)
          current_email.click_link 'Confirm my account'

          expect(page).to have_content 'Your email address has been successfully confirmed.'
        end

        scenario 'can not sign in by github with invalid email' do
          fill_in 'Email', with: nil
          click_on 'Resend confirmation instructions'

          expect(page).to have_content "Email can't be blank"
        end
      end
    end
  end
end
