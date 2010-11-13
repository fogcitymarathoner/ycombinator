class CreateResearchTagAssociations < ActiveRecord::Migration
  def self.up
    create_table :research_tag_associations do |t|
      
       t.timestamps
        t.integer :research_id
        t.integer :tag_id
        
    end
  end

  def self.down
    drop_table :research_tag_associations
  end
end
