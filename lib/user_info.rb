module UserInfo


      @loggeduser  
  
  def logged_user

    Thread.current[:user]
  end
 
  def self.logged_user=(user)
    Thread.current[:user] = user
  end
  


end