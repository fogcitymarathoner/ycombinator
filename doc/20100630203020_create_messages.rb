class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :title
      t.text :body
      t.integer :recipient_id
      t.integer :sender_id
      t.datetime :created_at
      t.datetime :deleted_at
      t.datetime :read_at

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
