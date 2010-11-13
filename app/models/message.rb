class Message < ActiveRecord::Base
  validates_presence_of :title, :body, :recipient_id, :sender_id
  belongs_to :sender, :class_name => "Profile", :foreign_key => "sender_id"
  belongs_to :recipient, :class_name => "User", :foreign_key =>"recipient_id"
  attr_accessible :title, :body, :recipient_id, :sender_id, :deleted_recieved
  
  
  #def ensure_not_sending_to_self
   # errors.add_to_base("You may not send a message to yourself.") if self.recipient_id && self.recipient_id.eql?(self.sender_id)    
  #end
  
  # aliases read_at accessor attribute to make it read more nicely
  def read?
    read_at
  end
  
  def message_read
    message = Message.find(id)
    if message.read_at.nil?
       message.read_at = Time.now
       message.save!
    end
  end
  
  # returns the opposite_party in the messsage to given user. So if the given user is the recipient,
  # this method returns the sender and vice versa. If the given user is neither a recipient nor sender
  # (e.g. because they're an editor) it returns the recipient. If the given user is nil (e.g. because
  # the current_user is nil) an exception is raised
  def partner_to(user)
    raise ArgumentError unless user
    user.id == recipient_id ? sender : recipient
  end
  
  def recieved
       r = created_at
       r.to_s
       r.strftime("%B %d, %I:%M %p")
  end
  
  def multiple_actions
    if params[:commit] == "Delete"
      message.deleted_reciever
    elsif params[:commit] == "Archive"
      message.archive
    end
  end
  
  
  def count
    m = Message.all
    count = m.count(:all)
  end
  

  
end
