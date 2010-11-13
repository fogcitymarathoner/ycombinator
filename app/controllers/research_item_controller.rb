class ResearchItemController < ApplicationController

  require 'solr'

  require 'rubygems'
  require 'open-uri'
  require 'mechanize'
  
   require 'uri'
  require 'will_paginate'
  
  include ProcessResearch
  
  
  
    /before_filter :require_user, :only => [:new, :create, :show, :edit, :update]/
    before_filter :require_user, :except => []
    
    
  def related
    
      render_cell :library, :related

    
  end


   def saveitem
     logger.debug "begin saveitem"
     url = params[:url]
     title = params[:title]
     
     tagtext = params[:tagtext]
     
     dialogue_association = params[:dialogue_association]
     
     puts url
     puts title
     puts tagtext
     
     
     @research_item = ResearchItem.new
     
     @research_item.dialogue_association = dialogue_association
     
      @tags = Tag.new
      @tags.tagtext = tagtext
      
       @link = Link.new

       @link.url =  url
       @link.title = title
       
         logged_user = UserSession.find.user



         userid = logged_user.id



          create_research(userid, @research_item, @link, @tags)
     logger.debug "end saveitem"
     
   end
    
    
    def createresearch
      
          url = params[:url]
          title = params[:title]

          @ResearchItem = ResearchItem.new
          @Tag = Tag.new
          @Link = Link.new

          @Link.url =  url
          @Link.title = title

          /@ResearchItem.url = url/
          /@ResearchItem.title = title/

    end
    
   def new  
     
        url = params[:url]
        title = params[:title]
        
        @ResearchItem = ResearchItem.new
        @Tag = Tag.new
        @Link = Link.new
        
        @Link.url =  url
        @Link.title = title
        
        /@ResearchItem.url = url/
        /@ResearchItem.title = title/
        
           respond_to do |format|
             
             format.html { render :new }
        	   
          
          end
        
  end
  
  def partial  
     
     
        url = params[:url]
        title = params[:title]
        
        @ResearchItem = ResearchItem.new
        @Tag = Tag.new
        @Link = Link.new
        

        
       @Link.url =  url
       @Link.title = title
        
        /@ResearchItem.url = url/
        /@ResearchItem.title = title/
        
        
           respond_to do |format|
        
             format.html { render :partial => "create_research" }
             
          end
        
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
    
    @research = ResearchItem.new
    
    @research.id = 1
      
#      @posts = Post.paginate_by_board_id @board.id, :page => params[:page], :order => 'updated_at DESC'
      
      @ResearchItems
      #sitesinrange = Site.find(:all, :include => :chargers, :conditions => ["chargers.connector = ?", "a"])
      
      if (researchids.size>0) 
      @ResearchItems = ResearchItem.find(:all, :order => 'created_at desc', :conditions => ["id in (?) ", researchids])
    else
       @ResearchItems =   ResearchItem.paginate :page => page, :per_page => 10, :order => 'created_at DESC'
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
     
      
   end
   
   def tagsarray
     
     
       @ritags = Tag.find(:all, :conditions =>"research_item_id='"+@ResearchItem.id.to_s+"'")

        tagtext = []

        @ritags.each do |r|
         tagtext << r
       end
     
     return tagtext
     
   end
   def myresearch
     
          @title = "Research"
          @Tag = Tag.new
    
   end
   
   def show
  
     @ResearchItem = ResearchItem.find(params[:id])
     @Tag = Tag.find(:all)
     
     @ritags = Tag.find(:all, :conditions =>"research_item_id='"+@ResearchItem.id.to_s+"'")
     
     
     @Link = Link.find(research_item_id=@ResearchItem.id)


  end
  
  
  def add_tag_to_research
    
    

    logged_user = UserSession.find.user
    
    userid = logged_user.id
    
      tagtexttemp = params[:tagtext]
      
      tagtext = CGI::unescape(tagtexttemp)

      researchid = params[:researchid]
    
      
      @ResearchItem = ResearchItem.find(researchid)
    
     @newtag = Tag.new
     
      @newtag.tagtext = tagtext.downcase;
      @newtag.research_item_id = @ResearchItem.id;
      @newtag.created_by = userid;
      @newtag.save!
      
      
      @ritags = ResearchTagAssociation.find(:all, :conditions => "research_id='"+researchid+"'")
      
      
      @ritags.each do |ri|
    
        @ta = TagAssociation.new
        @ta.tag1 = @newtag.id
        @ta.tag2 = ri.tag_id
        @ta.save!
        
      end
      
      @rinew = ResearchTagAssociation.new
      @rinew.tag_id = @newtag.id
      @rinew.research_id = researchid
      @rinew.save!
      

     #tags = ''
     #tagscommas = ''
     
     #@ResearchItemTags = Tag.find(:all, :conditions =>"research_item_id='"+researchid+"'")
     

      #count = 1
     
      # @ResearchItemTags.each do |ri|

       #   if (count==1)
      #               tagscommas = ri.tagtext;
       #              tags = ri.tagtext;

      #    elsif count==@ResearchItemTags.size
      #      tagscommas = tagscommas+','+ ri.tagtext
      #      tags = tags+' '+ ri.tagtext

      #    else
       #   tagscommas = tagscommas+','+ri.tagtext
      #    tags = tags+' '+ri.tagtext          
      #   end

      #    count = count+1
      #  end
    
     
       # conn = Solr::Connection.new('http://127.0.0.1:8982/solr', :autocommit => :on)


      #  puts 'Going to update: '+researchid + ' : '+tagscommas
      
      
      #conn.add(:id => id, :title => title, :tags => tagtext, :author => author, :url => url, :textbody => nodelist.text, :tagscommas=> tags)
     
      redirect_to :action => :myresearch
    
  end


    def add_tag_to_existing_research

    if params[:tags].nil?

    logged_user = UserSession.find.user

    userid = logged_user.id

      tagtexttemp = params[:tagtext]

      tagtext = CGI::unescape(tagtexttemp)

      researchid = params[:researchid]


      @research_item = ResearchItem.find(researchid)

      textarray = tagtext.split(',');

      newtags = []

      for t in textarray
         @newtag = Tag.new
         @newtag.research_item_id = @research_item.id;

         stripped = t.gsub(%r{</?[^>]+?>}, '')
         stripped = stripped.strip
         @newtag.tagtext = stripped.downcase;
         @tempTag = Tag.find(:first, :conditions => ["tagtext = ? and research_item_id= ?" ,  @newtag.tagtext, @research_item.id])
         if (@tempTag.nil?)
          @newtag.created_by = userid;
          @newtag.save!
          newtags << @newtag
         end
       end

       for tag in newtags

         @retag = ResearchTagAssociation.new
         @retag.research_id = @research_item.id
         @retag.tag_id = tag.id
         @retag.save!

       end

       already_associated = []

       for tag in newtags
         tagid = tag.id;

         for assoc in newtags
           associd = assoc.id

           sum = tagid + associd
           if ((tagid != associd)&&!already_associated.include?(sum))
           @tagassociation = TagAssociation.new
           @tagassociation.tag1 = tagid
           @tagassociation.tag2 = assoc.id

           already_associated<< sum

           @tagassociation.save!
         end

         end

       end

      
     #tags = ''
     #tagscommas = ''

     #@ResearchItemTags = Tag.find(:all, :conditions =>"research_item_id='"+researchid+"'")


      #count = 1

      # @ResearchItemTags.each do |ri|

       #   if (count==1)
      #               tagscommas = ri.tagtext;
       #              tags = ri.tagtext;

      #    elsif count==@ResearchItemTags.size
      #      tagscommas = tagscommas+','+ ri.tagtext
      #      tags = tags+' '+ ri.tagtext

      #    else
       #   tagscommas = tagscommas+','+ri.tagtext
      #    tags = tags+' '+ri.tagtext
      #   end

      #    count = count+1
      #  end


       # conn = Solr::Connection.new('http://127.0.0.1:8982/solr', :autocommit => :on)


      #  puts 'Going to update: '+researchid + ' : '+tagscommas


      #conn.add(:id => id, :title => title, :tags => tagtext, :author => author, :url => url, :textbody => nodelist.text, :tagscommas=> tags)
    end

    redirect_to :action => :myresearch

  end

   
   def create


    logged_user = UserSession.find.user
    

    
    userid = logged_user.id
    
      @research_item = ResearchItem.new(params[:research_item])

      @tags = Tag.new(params[:tags])

      @links = Link.new(params[:link])

     create_research(userid, @research_item, @links, @tags)
     #create_research()
     redirect_to :action => :myresearch
     
   end
    

  
end
