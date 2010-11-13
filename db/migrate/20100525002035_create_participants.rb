class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :profile_id
      t.string :role, :null=> false
      
  end
  add_index :participants, [:project_id, :user_id], :unique => false
  add_index :participants, :user_id, :unique => false
  end

  def self.down
    drop_table :participants
  end
end
