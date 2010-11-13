class HubController < ApplicationController

  def hubhome
    @title = "Hub"
    @announcements = Announcement.find_most_recent
    @watched_project_count = @current_profile.watched_project.count
    @participant_project_count = @current_profile.participant_project.count
    @team_leader_badge = @current_profile.team_leader_badge
    @messages = @current_user.received_messages
    @unread_messages = @current_user.unread_messages
  end
  
  def hubhome_participation
    @title = "Hub"
    @announcements = Announcement.find_most_recent
    @watched_project_count = @current_profile.watched_project.count
    @participant_project_count = @current_profile.participant_project.count
    @team_leader_badge = @current_profile.team_leader_badge
    @messages = @current_user.received_messages
    @unread_messages = @current_user.unread_messages
  end
  
    def hubhome_watching
    @title = "Hub"
    @announcements = Announcement.find_most_recent
    @watched_project_count = @current_profile.watched_project.count
    @participant_project_count = @current_profile.participant_project.count
    @team_leader_badge = @current_profile.team_leader_badge
    @messages = @current_user.received_messages
    @unread_messages = @current_user.unread_messages
  end
 
  def watched_projects
  end

  def projectadmin
    @title = "Project Admin"
  end

  def myparticipation
      @title = "myParticipation"
      @subtitle = ": myParticipation"
  end

end
