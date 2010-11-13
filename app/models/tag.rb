
class Tag < ActiveRecord::Base
  def before_create() 
    newid = Array.new(9){rand 10}.join
    self.id =  newid
   end
   
  @@origtagtext = ''
    
  belongs_to :research_item
  has_and_belongs_to_many :links
end
