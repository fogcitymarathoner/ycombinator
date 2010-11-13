class ProjectController < ApplicationController
  layout "project", :except => [:new, :index, :project_admin_team]
  before_filter :load_project, :only => [:team_leader, :project,:project_teaser,:project_plan, :project_description, :project_about, :project_workspace, :project_participant_plan_key, :project_admin_plan_key, :project_admin_team, :project_admin_plan, :project_admin, :title_base, :project_participant_mentor, :project_participant_plan, :project_participant_members, :project_team_members, :project_participant_team, :project_setup, :watch_this, :project_public_inside, :project_admin, :project_participant]
  before_filter :title_base, :only => [:project, :project_participant, :project_workspace, :project_public_inside]
  before_filter :require_user, :except => []

  def index
    @title = "Projects"
    @projects = Project.all
  end

  def new

     @project = Project.new
     @title = "Create A Project"
  end

  def create
     @project = Project.new(params[:project])
     @form_step = params[:form_step]
     @wizard = params[:wizard]
      wizard = '0'
      wizard.succ!

     @project.save!

     id = @project.id

     @team_leader_indicator = Participant.new(
      :role => 'team_leader',
      :project_id => @project.id,
      :profile_id => @current_profile.id,
      :user_id => @current_user.id)
     @team_leader_indicator.save!

# Create the Project Plan Questions as Dialogues

 #   Removing auto-generated discussion items on project creation
 #    create_plan_questions

 #   removed redirect until setup wizard is properly built...
 #   redirect_to '/project_setup?id='+id.to_s+'&wizard='+wizard.to_s

     redirect_to '/project?id='+id.to_s
   end

  def project_admin
    @title = @Project.projectname+' : Admin'
    @dialogue = Dialogue.find(:all, :order => 'created_at desc', :conditions =>"project_id='"+@Project.id.to_s+"' and is_project_update=true")
      if (@dialogue.length()>0)
        @dia = @dialogue[0]
      else
        @dia = Dialogue.new
        @dia.body = 'Your project updates go here'
      end
  end

  def project_admin_team

  end

  def project_admin_plan
    @plan_questions = Dialogue.find_all_by_project_id_and_dialogue_type_and_is_reply(params[:id],'plan_item',false)
  end

    def project_admin_plan_key
  end

  def project
    @update = Update.new
    @updates = Update.find(:all, :order => 'created_at desc', :conditions =>'project_id='+@Project.id.to_s)




  end



  def watch_this
        @watcher = Participant.new(
          :role => 'watcher',
          :project_id => @Project.id,
          :profile_id => @current_profile.id,
          :user_id => @current_user.id)
        @watcher.save!
     redirect_to '/project'
  end

  def find_project_by_name
      str = params[:name]
      str = str.sub( "project: ", "" )
      project = Project.find_by_projectname(str)
      unless project.nil?
        redirect_to :controller =>'project', :action =>'project_workspace', :id => project.id
      else
        redirect_to :controller => 'research_item', :action => 'myresearch'
      end
  end

  def myparticipation
      @title = "Hub : myParticipation"
  end

  def project_workspace
    @Dialogue = Dialogue.find(:all, :order => 'created_at desc', :conditions =>"project_id='"+@Project.id.to_s+"' and is_project_update=false")

    puts 'returning dialogue; '+@Dialogue.size().to_s


  end

  def update_tease

    projid = params[:projid]
    new_tease = params[:projtease]
    @Project = Project.find(projid)

    @Teaser = Project.find(projid)
    @Teaser.project_teaser = new_tease
    @Teaser.save

    redirect_to '/project_teaser?id='+projid
  end
    def update_logo

    projid = params[:projid]
    new_logo = params[:logo]
    @Logo = Project.find(projid)
    @Logo.logo = new_logo
    @Logo.save

    redirect_to '/project_teaser?id='+projid
  end
  



    def update_about

    projid = params[:projid]
    new_about = params[:projabout_input]
    @Project = Project.find(projid)

    @About = Project.find(projid)
    @About.project_about = new_about
    @About.save

    redirect_to '/project_about?id='+projid
  end

    def update_description

    projid = params[:projid]
    new_description = params[:projdescription_input]
    @Project = Project.find(projid)

    @Description = Project.find(projid)
    @Description.project_description = new_description
    @Description.save

    redirect_to '/project_description?id='+projid
  end

   def project_desc_embed

    projid = params[:projid]
    @Desc_Embed = Project.find(projid)
     respond_to do |format|
      if @Desc_Embed.update_attributes(params[:desc_embed])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to '/project_description?id='+projid}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @update.errors, :status => :unprocessable_entity }
    end
    end
  end

  def project_about_embed

    projid = params[:projid]
    @About_Embed = Project.find(projid)
     respond_to do |format|
      if @About_Embed.update_attributes(params[:about_embed])
        format.html { redirect_to '/project_about?id='+projid}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @update.errors, :status => :unprocessable_entity }
    end
    end
  end

  def edit


    projid = params[:projid]

    body = params[:projinput]

    puts body

    @Project = Project.find(projid)

    @Dialogue = Dialogue.new
    @Dialogue.project_id = @Project.id
    @Dialogue.is_project_update = true;
    @Dialogue.body = body
    @Dialogue.save



    redirect_to '/project_participant?id='+projid
    end

  def project_participant_team
    @title = @Project.projectname+' : Team'
  end

  def project_plan
    @title = @Project.projectname+' : Plan'
    @plan_questions = Dialogue.find(:all, :conditions =>["project_id=? and dialogue_type=? and is_reply=? and `show`=?", params[:id],'plan_item',false,true])
  end

  def project_research
    @Project = Project.find(params[:id])
    @title = 'Project : Research'
  end

  def project_participant_mentor
    @title = @Project.projectname+' : Mentor'
  end

  def update_show_status
    @dialogue = Dialogue.find(params[:id])
    @dialogue.show = !@dialogue.show
    @dialogue.save!
    render :nothing => true
  end

  private
    def load_project
      @Project = Project.find(params[:id])
    end

    def title_base
      @title = @Project.projectname
    end

    def create_plan_questions
    	questions = ['What do you plan to make?',
	'What is new or innovative about your product or service?',
	'What Was the Specific Situation that Was Behind the Genesis of this Idea?',
	'What are potential customers/users required to do today that they will be spared when your product is available?',
	'How will your company make money?',
	'What is it about your understanding of the opportunity that your competitors have missed?',
	'What keeps your competitors from changing their business to pursue your idea?',
	'Who are your competitors today?',
	'Who are potential competitors tomorrow?',
	'What competitive threat do you fear most and why?',
	'How do you plan to prove the viability of your idea?',
	' In your opinion, under what circumstances will your idea be sufficiently proven that money backing your project would be considered an investment rather than speculation? What milestones over what time frame need to be reached to reach those circumstances?',
	'Name the key risks to your project prior to proof of concept.',
	'Name the key risks to your project after proof of concept.'
        ]

	questions.each do |q|
	   dialogue = Dialogue.new
	   dialogue.title = q
#	   dialogue.dialogue_type = 'plan_item'
	   dialogue.project_id = @project.id
     dialogue.author = @current_user.id
     dialogue.save!
	end
    end



end

