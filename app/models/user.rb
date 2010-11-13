class User < ActiveRecord::Base
   acts_as_authentic
   has_one :profile
   has_and_belongs_to_many :participants
   has_and_belongs_to_many :projects
   has_many :sent_messages, :class_name => "Message", :foreign_key =>"sender_id", :order => 'created_at DESC'
   has_many :received_messages, :class_name => "Message", :foreign_key =>"recipient_id", :conditions => ['deleted_reciever IS NULL'], :order =>'created_at DESC'
   has_many :unread_messages, :class_name => "Message", :foreign_key =>"recipient_id", :conditions => ['read_at IS NULL AND deleted_reciever IS NULL'], :order => 'created_at DESC' 
end
