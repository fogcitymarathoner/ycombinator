class LibraryCell < ::Cell::Base


  def related


    associated_id = params[:associated_id]
     


     @ResearchItems = ResearchItem.find (:all, :order => 'created_at desc', :conditions => ["dialogue_association= "+associated_id])
     @tagshash = {}
      
      @ResearchItems.each do |item|

         @ritagids = ResearchTagAssociation.find(:all, :conditions =>"research_id='"+item.id.to_s+"'")

         ids = []
         @ritagids.each do |r|
           ids << r.tag_id
         end

         @ritags = Tag.find(:all, :conditions => ["id in(?)", ids] )
         
         size = @ritags.size
         
         @tagshash[item.id] = @ritags


       end

     render
   end
  
  def recent
    
    logged_user = UserSession.find.user

       userid = logged_user.id
       
       page = 1;
       
        @tags = Tag.find(:all,:select => 'DISTINCT tagtext, created_at', :conditions => {:created_by=>userid, :created_at => (Time.now-30.days)..(Time.now+10.days)}, :limit=>8, :order => 'created_at DESC')
        #@tags = Tag.paginate(:page => page, :per_page=>10 ,:select => 'DISTINCT tagtext', :conditions => {:created_by=>userid, :created_at => (Time.now-30.days)..(Time.now+10.days)})
        
        @tags.each do |t|
          if (t.tagtext.length>20)

            t.tagtext = t.tagtext[0..20]+'...'

          end
        end
        
         
    render
    
  end
  
  def list
       page = params[:page]
       
        
        if page==nil
          page = 1
        end
      
      tag = params[:tag]
      
      researchids = []
      @filtertags
      if (tag)
      
      @filtertags = Tag.find(:all, :conditions =>"tagtext='"+tag+"'")
      
      @filtertags.each do |filtertag|
        researchids << filtertag.research_item_id
      end
      
      
    end
    
    logged_user = UserSession.find.user
    
      userid = logged_user.id
      
#      @posts = Post.paginate_by_board_id @board.id, :page => params[:page], :order => 'updated_at DESC'
      
      @ResearchItems
      #sitesinrange = Site.find(:all, :include => :chargers, :conditions => ["chargers.connector = ?", "a"])
      
         if (researchids.size>0) 
          @ResearchItems = ResearchItem.find (:all, :order => 'created_at desc', :conditions => ["id in (?) and created_by=(?)", researchids, userid])
        else
           @ResearchItems =   ResearchItem.paginate :page => page, :per_page => 10, :order => 'created_at DESC', :conditions => ["created_by=(?)", userid ]
           #ResearchItem.paginate_by_board_id @research.id ,:page => page, :order => 'created_at desc'
         end

      @tagshash = {}
      
      @ResearchItems.each do |item|
        
        @ritagids = ResearchTagAssociation.find(:all, :conditions =>"research_id='"+item.id.to_s+"'")
        
        ids = []
        @ritagids.each do |r|
          ids << r.tag_id
        end
        
        puts ids
        
        @ritags = Tag.find(:all, :conditions => ["id in(?)", ids] )
        @ritags
        size = @ritags.size
       
        @tagshash[item.id] = @ritags
        
        
      end
   
   
    render
 end

  def list_for_project

       logger.debug 'params in list_for_project'
       logger.debug params
       page = params[:page]

        if page==nil
          page = 1
        end
      
      project = Project.find(params[:id])
      proj_tagname = 'project: ' + project.projectname
      
      usersId = []
      
      project.participants.each do |user|
          usersId << user.id
      end
     
      usersId << project.team_leader.id unless project.team_leader.nil?
      
      @filtertags
      
      logged_user = UserSession.find.user

      userid = logged_user.id
      usersId << userid

      research = ResearchItem.find (:all, :order => 'created_at desc', :conditions => ["created_by in (?)", usersId])
    
      @tagshash = {}
      
        @ResearchItems = []

        research.each do |item|

        @ritagids = ResearchTagAssociation.find(:all, :conditions =>"research_id='"+item.id.to_s+"'")

        ids = []
        @ritagids.each do |r|
          ids << r.tag_id
        end

        temp = Tag.find(:first, :conditions => ["id in(?) and tagtext = (?)", ids, proj_tagname] )
        unless temp.nil?
          @ResearchItems << item
          @tagshash[item.id] = Tag.find(:all, :conditions => ["id in(?)", ids] )
        end


      end

    
    render
 end
 
 end
 
 