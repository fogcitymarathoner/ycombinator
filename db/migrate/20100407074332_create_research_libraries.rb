class CreateResearchLibraries < ActiveRecord::Migration
  def self.up
    create_table :research_libraries do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :research_libraries
  end
end
