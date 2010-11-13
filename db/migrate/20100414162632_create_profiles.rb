class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
          t.string     :firstname, :limit => 255, :null => false  
          t.string     :lastname, :limit => 255, :null => false   
          t.string     :middleinitial, :limit => 1, :null => true
          t.string     :email, :limit => 255, :null => false
          t.string     :city, :limit => 255, :null => true
          t.string     :state, :limit => 255, :null => true
          t.integer    :zipcode, :limit => 5, :null => true                    
          t.string     :timezone, :limit => 255, :null => true
          t.integer    :user_id, :null =>false
          t.string     :headline, :limit => 255
          t.string     :summary, :limit => 3000
          t.timestamp  :created_at
          t.string      :avatar_file_name
          t.string      :avatar_content_type
          t.integer     :avatar_file_size
          t.datetime    :avatar_updated_at
    end

  end

  def self.down
    drop_table :profiles
  end
end
 