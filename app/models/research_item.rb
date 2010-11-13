class ResearchItem < ActiveRecord::Base
  
    cattr_reader :per_page
    @@per_page = 5
  
   belongs_to :research_library
   has_many :tags
   has_many :links
   has_many :linkages
   belongs_to :user
   has_and_belongs_to_many :dialogues
   
   
end
