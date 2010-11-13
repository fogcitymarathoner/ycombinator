class ProfileController < ApplicationController

def myaccount
     @profile = Profile.find(:first, :conditions => [ "user_id='"+UserSession.find.user.id.to_s+"'"], :limit => 1)
     @title = "Profile"
     render :template => "profile/myaccount"
end


 def watched_project
   @watched_project = @current_profile.watched_project
 end

end
