class CreateDialogues < ActiveRecord::Migration
  def self.up
    create_table :dialogues do |t|

      t.string	   :dialogue_type
      t.text       :body
      t.text     :title
      t.integer    :project_id
      t.boolean    :is_project_update, :default => false
      t.string     :author
      t.boolean    :is_reply, :default => false
      t.boolean    :show, :default => true
      t.integer    :dialogue_id
      t.references :parent
      t.column     :research_association, 'bigint'


      t.timestamps
    end
  end

  def self.down
    drop_table :dialogues
  end
end

