class DialogueController < ApplicationController

  require 'solr'
  require 'rubygems'
  require 'sanitize'
  require 'open-uri'
  require 'mechanize'

  include ProcessResearch

  def show
    @Dialogue = Dialogue.find(params[:id])


  end


  def save
  logger.debug "create dialogue"

    projid = params[:projid]

    title = params[:title_text]
    dialogue_body = params[:dialogue_body]

    dialogue_title = params[:dialogue_title]

    dialogue_author = params[:dialogue_author]

    is_reply = params[:is_reply]


    dialogue_id = params[:dialogue_id]


    research_association = params[:research_association]

    url = params[:url]
    research_title = params[:research_title]
    tagtext = params[:tagtext]
    dialogue_association = params[:dialogue_association]

#    if (research_title && research_title!='' && url && url!='' && url!='undefined')
#     puts url
#      puts title
#      puts tagtext
#      @research_item = ResearchItem.new
#      @research_item.dialogue_association = dialogue_association

#      @tags = Tag.new
#      project_temp = Project.find(projid)
#      @tags.tagtext = tagtext + "project: #{project_temp.projectname}" unless project_temp.nil?

#      @link = Link.new
#      @link.url =  url
#      @link.title = research_title

 #     logged_user = UserSession.find.user
 #     userid = logged_user.id
 #     logger.debug 'before create_research'
 #     create_research(userid, @research_item, @link, @tags)
 #  end


    @dia = Dialogue.new

    if (is_reply.blank?)

        @dia.is_reply = 'false'

    else
       @dia.is_reply = is_reply
       @dia.parent_id = dialogue_id
    end




    @dia.body = dialogue_body


    @dia.research_association = research_association

    @dia.author = dialogue_author

    @dia.title = dialogue_title

    @dia.project_id = projid.to_i

    @dia.save!


    redirect_to '/project_workspace?id='+projid



  end


  def save_reply
    dialogue = Dialogue.new(params[:dialogue])
    dialogue.author = @current_user.id
    dialogue.project_id = Dialogue.find(dialogue.parent_id).project_id
    dialogue.is_reply = true
    dialogue.dialogue_type = 'plan_item'
    dialogue.save!
    redirect_to "/project_participant_plan?id=#{dialogue.project_id}"
  end

  def save_reply_admin
    dialogue = Dialogue.find(params[:dialogue][:id])
    dialogue.body = params[:dialogue][:body]
    dialogue.author = @current_profile.id
    dialogue.save!
    redirect_to "/project_admin_plan?id=#{dialogue.project_id}"
  end

  def project_plan_show_answer_box_admin
    @dialogue = Dialogue.find(params[:id])
    render(:layout => false)
  end

  def project_plan_show_answer_box
    @dialogue = Dialogue.new
    @dialogue.parent_id = params[:id]
    render(:layout => false)
  end
end

