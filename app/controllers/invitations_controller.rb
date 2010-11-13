class InvitationsController < ApplicationController
  # TODO Userless access only to show
  #before_filter :require_no_user, [:show, :edit]
  
  def new
    @invitation = Invitation.new
    @invitation.project_id = params[:id]
  end
  
  def create
    @invitation = Invitation.new(params[:invitation])
    #TODO Form validation and cleanup
    @invitation.token = create_token
    #TODO Verify exisitng user in database. If exists, just flag it as participant and redirect.
    
    #Verify if an invitation to this user exists. If it exists, use same token.
    if @verify_user = Invitation.find_by_email(@invitation.email)
      @invitation.token = @verify_user.token if @invitation.email == @verify_user.email
    end

    if @invitation.save
      # Send invitation by email
      AppMailer.deliver_invite(@invitation, current_profile)
      
      flash[:notice] = "Invitation was sent successfuly!"
      redirect_to "/project_admin?id=#{@invitation.project_id}" and return false
    else
      flash[:notice] = "An error ocurred while sending the email!"
      redirect_to "/project_admin?id=#{@invitation.project_id}" and return false
    end
  end
  
  def show
    @invitations = Invitation.find_all_by_project_id(params[:id])
  end
  
  def edit
    if @invitation = Invitation.find_by_token(params[:id])
       #Check if the users exists and already has assigned the requested project
       if Participant.find_by_user_id_and_project_id(User.find_by_login(@invitation.email),@invitation.project_id)
          flash[:notice] = "You are already joined into the project"
          redirect_to "/project_participant?id=#{@invitation.project_id}" and return false
       #If not assigned to the project, check if it is already an existing user
       #If it is already a user, join the user to the requested project.
       elsif @user = User.find_by_login(@invitation.email)
          @participant = Participant.new
          @participant.project_id = @invitation.project_id
          @participant.user_id = @user.id
          @participant.profile_id = @user.profile.id
          @participant.role = "participant"
          @participant.save
          #TODO check for save errors
          redirect_to "/project_participant?id=#{@invitation.project_id}" and return false
       end
       
       @invitation.accepted_at = Time.now
       @invitation.save
       
       session[:invitation_user] =  {:email => @invitation.email, :project_id => @invitation.project_id}
       redirect_to "/" and return false
    else
      flash[:notice] = "Token is invalid. Please contact the project leader for a new invitation"
      redirect_to "/loginfail"
    end
  end
 
  private
  def create_token
     @token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end
