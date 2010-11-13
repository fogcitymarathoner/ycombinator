class AppMailer < ActionMailer::Base
  
  def invite(invitation, current_profile)
    recipients invitation.email
    from "3stidestest@gmail.com"
    subject "You have been invited to join a project"
    body :user => current_profile, :invitation => invitation
  end

end
