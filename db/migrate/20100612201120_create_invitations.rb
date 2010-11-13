class CreateInvitations < ActiveRecord::Migration
  def self.up
      create_table :invitations do |t|
          t.string     :email, :limit => 255, :null => false          
          t.integer    :project_id, :null =>false
          t.string     :token
          t.datetime   :accepted_at
          t.timestamps
      end
  end

  def self.down
     drop_table :invitations
  end
end
