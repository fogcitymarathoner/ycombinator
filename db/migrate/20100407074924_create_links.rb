class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string     :url, :limit => 255, :null => false
      t.string     :title, :limit => 255, :null => true
      t.integer    :research_item_id
      t.timestamp  :created_at
    end
  end

  def self.down
    drop_table :links
  end
end
