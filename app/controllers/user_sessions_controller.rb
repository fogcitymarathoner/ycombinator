class UserSessionsController < ApplicationController



  
  before_filter :require_no_user, :only => [:create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new  
  end

  def new_message
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    
    
    if @user_session.save
      
      puts 'Creating user'
      puts UserSession.find.user
      puts 'Done creating user'
      
      flash[:notice] = "Login successful!"
          puts 'xxxxxxxxxxxxx'
          puts user_path
      redirect_to '/hubhome'
      
    else
      respond_to do |wants|  
        wants.html { redirect_to '/loginfail'}  
     end
  end
end
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to '/'
  end
end