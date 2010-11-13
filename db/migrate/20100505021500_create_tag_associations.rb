class CreateTagAssociations < ActiveRecord::Migration
  def self.up
    create_table :tag_associations do |t|

      t.timestamps
      t.integer :tag1
      t.integer :tag2
    end
  end

  def self.down
    drop_table :tag_associations
  end
end
