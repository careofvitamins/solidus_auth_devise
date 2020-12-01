# frozen_string_literal: true

class Spree::Admin::UserPasswordsController < Devise::PasswordsController
  helper 'spree/base'

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Store

  helper 'spree/admin/navigation'
  layout 'spree/layouts/admin'

  skip_before_action :require_no_authentication, only: [:create]

  # Devise::PasswordsController allows for blank passwords.
  # Silly Devise::PasswordsController!
  # Fixes spree/spree#2190.
  def update
    if params[:spree_user][:password].blank?
      set_flash_message(:error, :cannot_be_blank)
      render :edit
    else
      super
    end
  end

  private

  def after_sending_reset_password_instructions_path_for(_)
    spree.admin_login_path
  end
end
