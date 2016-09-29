class Spree::UserInvitationsController < Devise::InvitationsController
  skip_before_filter :authenticate_inviter!, :only => [:new, :create]
  skip_before_filter :has_invitations_left?, :only => [:create]

  def edit
    sign_in resource
    redirect_to spree.new_spree_user_invitation_path
  end

  protected
  def authenticate_inviter!
    inviter = send(:"authenticate_#{resource_name}!")
    return inviter if inviter

    Spree::User.find_or_create_by!(email: Figaro.env.email_from_address!) do |user|
      user.password = 'P8FA9sEXzs'
    end
  end

end