class RegistrationController < ApplicationController
  
   def new
     @user = User.new
     @profile = Profile.new
     
     # This section below only runs if the registration comes from an invitation. It attaches the new user
     # to an existing project when saved on the create step.
     # A new session parameter :newuser is saved on the invitation controller. If it doesn't come from the
     # invitation controller, :newuser will not exist this code will not run.
     if session[:invitation_user]
        @participant = Participant.new
        @participant.project_id = session[:invitation_user][:project_id]
        @profile.email = session[:invitation_user][:email]
        session[:invitation_user] = nil
     end
     
   end
   
   def index
     @user = User.new
   end
   
   def create
     
      @user = User.new(params[:user])
      @profile = Profile.new(params[:profile])
      @participant = Participant.new(params[:participant])
            
      User.transaction do
  
        @user.password
        
        @user.login = @profile.email
        @user.save!
        
        @profile.user_id = @user.id
        
        @profile.save!
        
        if not @participant.project_id.nil?
          @participant.user_id = @user.id
          @participant.profile_id = @user.profile.id
          @participant.role = "participant"
          @participant.save!
          
          @Dialogue = Dialogue.new
          @Dialogue.project_id = @participant.project_id
          @Dialogue.is_project_update = true;
          @Dialogue.body = "Project Participant Request"
          @Dialogue.save
        end
        
        redirect_to '/hubhome'
        
      end
    rescue ActiveRecord::RecordInvalid => e
      @profile.valid?
      puts 'Error with something saving'
      puts e
      redirect_to '/'
    end
   
  
end
