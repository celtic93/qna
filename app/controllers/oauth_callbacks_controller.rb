class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user, only: :confirm_email

  def github
    sign_in_with_provider
  end

  def vkontakte
    sign_in_with_provider
  end

  def confirm_email
    if request.patch? && params[:user][:email]
      if @user.update(user_params)
        @user.send_confirmation_instructions
        redirect_to root_path, notice: 'Confirm your email'
      end
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def sign_in_with_provider
    @user = User.find_for_oauth(auth)

    if @user&.persisted? && @user.email_verified?
      sign_in_and_redirect(@user, event: :authentication)
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    elsif @user
      redirect_to confirm_email_path(id: @user.id)
    else
      redirect_to root_path, alert: 'Something wrong'
    end
  end

  def auth
    request.env['omniauth.auth']
  end
end
