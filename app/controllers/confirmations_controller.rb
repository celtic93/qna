class ConfirmationsController < Devise::ConfirmationsController
  def show
    super do |resource|
      sign_in(resource)
      redirect_to root_path, notice: 'Email confirmed'
      return
    end
  end
end
