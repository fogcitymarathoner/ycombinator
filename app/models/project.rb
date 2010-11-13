class Project < ActiveRecord::Base
  
     has_attached_file :logo, :styles => { :medium => ["200x200>",:png], :thumb => ["100x100>",:png] }
     has_many :updates
     has_many :dialogues
     has_many :participants
     has_many :users
     has_many :invitations
     has_many :participating, :through => :participants, :source => :profile,
              :conditions => "participants.role='participant'"    
     has_one  :team_leader, :through => :participants, :source => :profile,
              :conditions => "participants.role = 'team_leader'"
     has_many :project_watchers, :through => :participants, :source => :profile,
              :conditions => "participants.role = 'watcher'"
                  
     
     def start_date
       d = created_at
       d.to_s
       d.strftime("%B %d, %Y")
     end
     
     def remaining
       c = created_at.to_date
       n = Date.today
       d = (c - n).to_i
       r = 90 + d

       
     end
     
     def current_hurdle_badge
       if current_hurdle == 3
         '/images/H3_pin_64.png'
       elsif current_hurdle == 2
         '/images/H2_pin_64.png'
       elsif current_hurdle == 1
         '/images/H1_pin_64.png'
       end
     end
     
       
     def gallery_object
      '/gallery_object'
    end
    
    def participant_count
       participating.count+1
     end
     
     def watcher_count
       project_watchers.count
     end
     
     def is_watching(passed_profile)
        project_watchers.exists?(:id => passed_profile.id)
     end
     
     def is_participant(passed_profile)
        participating.exists?(:id => passed_profile.id)
     end
     
     def is_team_leader(passed_profile)
      
       team_leader.exists?(:id => passed_profile.id)
     end
        
     def plan_status_img
            plan_not_complete = "/images/plan_badge_status.png"
        if  is_plan_complete == false
            plan_not_complete
        else
            "/images/plan_badge_complete.png"
        end
    end
    
    def team_status_img
            team_not_complete = "/images/team_badge_status.png"
        if  is_team_complete == false
            team_not_complete
        else
            "/images/team_badge_complete.png"
        end
    end
    
    def mentor_status_img
            mentor_not_complete = "/images/mentor_badge_status.png"
        if  is_mentor_complete == true
            mentor_not_complete
        else
            "/images/mentor_badge_complete.png"
        end
      end
end


