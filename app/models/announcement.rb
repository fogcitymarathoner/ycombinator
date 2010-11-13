class Announcement < ActiveRecord::Base
  
  def self.find_most_recent
    find(:all, :order => "created_at DESC")
  end
end
