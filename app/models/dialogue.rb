class Dialogue < ActiveRecord::Base
  acts_as_tree :order => 'created_at desc'
  belongs_to :project
  has_many :dialogues
  has_and_belongs_to_many :research_items
  
end
