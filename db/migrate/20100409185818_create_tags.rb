class CreateTags < ActiveRecord::Migration
  def self.up
     create_table :tags do |t|
        t.string     :tagtext, :limit => 255, :null => false
        t.integer    :research_item_id
        t.timestamp  :created_at
        t.integer    :created_by  
      end
      
    end

  def self.down
  end
end
