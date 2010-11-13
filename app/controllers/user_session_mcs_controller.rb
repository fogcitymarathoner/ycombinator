class UserSessionMcsController < ApplicationController  
  
  layout :choose_layout
  def login
    @user_session = UserSession.new
  end
  
  def signup
    @user_session = UserSession.new
  end
  def validate_login
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      respond_to do |wants|
        wants.html do 
          flash[:notice] = "Login successful!"
          redirect_to user_path
        end
        
        wants.js { render :redirect }
      end
    else
      respond_to do |wants|
        wants.html { render :new }
        wants.js # create.js.erb
      end
    end
  end
  def validate_signup
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      respond_to do |wants|
        wants.html do 
          flash[:notice] = "Login successful!"
          redirect_to user_path
        end
        
        wants.js { render :redirect }
      end
    else
      respond_to do |wants|
        wants.html { render :new }
        wants.js # create.js.erb
      end
    end
  end

  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    #redirect_to 'root_path'
    redirect_to '/home_mc'
  end
  
  private
  def choose_layout
    (request.xhr?) ? nil : 'application'
  end
end