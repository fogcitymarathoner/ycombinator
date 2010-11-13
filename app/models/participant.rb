class Participant < ActiveRecord::Base
  belongs_to :project
  belongs_to :profile
  
  def is_leader
   if role == 'team_leader'
    @is_leader   = true
   else
     @is_leader = false
     end 
  end
end

