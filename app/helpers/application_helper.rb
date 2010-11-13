# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
   
    # Return a title on a per-page basis.
  def title
    base_title = "3Strides"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def subtitle
    base_title = ""
    if @subtitle.nil?
      base_title
    else
      "#{@subtitle}"
    end
  end
  
 # Returns the current user's Full Name.
  def display_name
      display_name = @current_profile.display_name
     end
 
   def display_name_short
      display_name_short = @current_profile.display_name_short
    end

 
 def public_display_name
   profile = Profile.find(params[:id])
   display_name = profile.display_name
 end

  

  # Noproject Indicator
  def noproject
    if @current_profile.owned_project.nil?
      base_noproject_link = '<a href="/noproject">'
    else
      base_noproject_link = '<a href=/project_participant?id='+@current_profile.owned_project.id.to_s+' class="myproject_link">Go To: ', @current_profile.owned_project.projectname    end
  end
  
    def noproject_menu
    if @current_profile.owned_project.nil?
      base_noproject_link = '/noproject'
    else
      base_noproject_link = '/project_admin?id='+@current_profile.owned_project.id.to_s
    end
  end
 
  # defines a users project
  def myproject
    myproject = @current_profile.owned_project
  end
  
  # defines a team_leader
  def team_leader
    team_leader = @Project.team_leader.id 
  end
 

 
end

