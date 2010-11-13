 class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table  :projects do |t|
      t.string    :projectname, :limit => 255, :null => false
      t.boolean   :is_code_name, :default => true
      t.string    :logo_file_name
      t.string    :logo_content_type
      t.integer   :logo_file_size
      t.datetime  :logo_updated_at
      t.string    :project_location, :limit => 255, :null => false
      t.integer   :current_hurdle, :default => 1
      t.string    :project_teaser, :limit => 330, :null => false, :default => "This is where you enter the teaser for your project that is displayed in the public project gallery."
      t.string    :project_about, :limit => 7200, :default => "This is where you enter the full description of your project that is seen by community members that are not participating in your project.  As such, please make sure that your description does not include information that you would consider sensitive in a public or semi-public forum."
      t.text      :about_embed
      t.string    :project_description, :default => "This is where you enter the detailed description of your project and goals for use by the participants of your project."
      t.text      :desc_embed
      t.boolean   :is_plan_complete, :default => false
      t.boolean   :is_team_complete, :default => false
      t.boolean   :is_mentor_complete, :default => false

       
      t.timestamps
     
      
    end
  end

  def self.down
    drop_table :projects
  end
end
