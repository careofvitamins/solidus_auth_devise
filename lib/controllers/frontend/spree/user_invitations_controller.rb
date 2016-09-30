class Spree::UserInvitationsController < Devise::InvitationsController
  include SemanticLogger::Loggable

  skip_before_filter :authenticate_inviter!, :only => [:new, :create]
  skip_before_filter :has_invitations_left?, :only => [:create]

  def edit
    sign_in resource
    redirect_to spree.new_spree_user_invitation_path
  end

  protected

  def after_invite_path_for(inviter, invitee)
    sign_in_user(invitee) unless current_spree_user

    redirect_to_user = inviter unless inviter == Spree::User.default_inviter
    redirect_to_user ||= invitee

    spree.new_spree_user_invitation_path(user_id: redirect_to_user.id)
  end

  def sign_in_user(invitee)
    logger.debug "Signing in invitee: #{invitee.email}"

    sign_in(invitee)
  end

  def authenticate_inviter!
    return current_spree_user if current_spree_user

    Spree::User.default_inviter
  end

end