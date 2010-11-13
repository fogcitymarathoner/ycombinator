# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user, :profile
  filter_parameter_logging :password, :password_confirmation
              before_filter :current_user
              before_filter :current_profile
              before_filter :participation
              

  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  #  filter_parameter_logging :password, :password_confirmation2
  # helper_method :current_user_session, :current_user
     
 
  

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

 def current_profile
          
        @testuser = @current_user
      unless @testuser.nil?

      return @current_profile if defined?(@current_profile)
               @current_profile = Profile.find(:first, :conditions => [ "user_id='"+UserSession.find.user.id.to_s+"'"], :limit => 1)
                @participation = Participant.new(
                   :role => 'none',
                   :project_id => 0,
                   :profile_id => 0,
                   :user_id => 0)
      
        else 
           @current_profile = Profile.new
      
        end
      
      
   end
   
   def participation
     
      @testuser = @current_user
      
      unless @testuser.nil?
        
      return @participation if defined?(@participation.id)
               @participation = Participant.find(:first, :conditions => [ "user_id='"+UserSession.find.user.id.to_s+"'"])
      
        else 

           @participation = Participant.new
             
      
        end
     
     
     
   end
   
 
   
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to :controller => :"/home_access"
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
  end
  
   def flashpopup
     @msg = params[:msg]
   end
  
  def messages
     @messages = current_user.received_messages
  end


    
  
end
