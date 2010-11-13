class TagController < ApplicationController

  def new  
        @tag = Tag.new
  end
  
  
  def mostrecent
    
    
        @tag = Tag.find(:all,  :conditions => ['created_at > '])
    
  end
  
  def searchtag
        
         query = params[:q];
        
          @findtags = Tag.find(:all, :conditions => ['tagtext LIKE ?', "%"+query+"%"])
          
          @findtags.each do |t|
            puts 'ID: '+t.id.to_s
          end
        
        orig = []
        @findtags.each do |ft|
          puts 'orig will contain: '+ft.id.to_s
          orig << ft.id
        end
        
       
          
          if (@findtags != nil) 
          
          @related = TagAssociation.find(:all,  :conditions => ["tag2 in (?) OR tag1 in (?)", @findtags, @findtags ])
        end
          
          ids = []
          
          @related.each do |r|
            
            if (!orig.include?(r.tag1))
                ids << r.tag1
              end
            if (!orig.include?(r.tag2))
                ids << r.tag2
          end
            
          end
          
          @tag = Tag.find(:all, :conditions => ['id in (?)', ids])
             
             
              render :template => "tag/searchtags"
              
    
  end
   
    def index
      @tags = Tag.find(:all, :conditions => ['tagtext LIKE ?', "%#{params[:q]}%"])
      #@tags = Tag.find(:all)
      respond_to do |format|
            format.js
          end
    end
    
    
    def indexjson
      @tags = Tag.find(:all, :conditions => ['tagtext LIKE ?', "%#{params[:q]}%"])
     
     
     
     resultsarray = []
     
     for t in @tags
        resultshash = {:id => t.id, :name => t.tagtext}
        resultsarray<<resultshash
      end
   
   
      
   
      @somethingelse =   @tags.collect {|o| {:id => o.id, :name => o.tagtext}}
      
      puts @somethingelse
      
      
      respond_to do |format|
        
        format.json { render :json => @tags.collect {|o| {:id => o.id, :name => o.tagtext}}}
          end

    end

    def list
      @tag = Tag.find(:all)
   end
    def show
      @tag = Tag.find(params[:id])
   end
  
      def create
      @tag = Tag.new(params[:tag])
    end
    
    
end
