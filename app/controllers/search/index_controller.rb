class Search::IndexController < ApplicationController
  
  # @link = Tag.new();
require 'solr'
require 'rubygems'
require 'sanitize'
require 'open-uri'
require 'mechanize'



   def getTitle() 
     
     
        url = params[:url]
     
       $mech = WWW::Mechanize.new
  
       title = $mech.get(url).title()
      

          
           respond_to do |format|

              format.js { render :js => title}
          end
          
      end
      
      def getTheTitle(url)
        
        
        
         $mech = WWW::Mechanize.new

         title = $mech.get(url).title()
        
        return title
        
        
      end
     
   

   def indexURL()
     
     url = params[:link]

     id = params[:researchid]
     
     tags = params[:tags]
     
     redirect_to_project = params[:redirect_to_project]
     
     if (redirect_to_project.nil?)
       redirect_to_project = 'false';
     end
     
     textarray = tags.split(',');
     
     tagtext = ''
     for t in textarray
        tagtext = tagtext+' '+t
      end
     
     title = params[:title]
     
     
     
     if title==nil
       title = getTheTitle(url)
     end

      $mech = WWW::Mechanize.new
      
      allhtml = $mech.get(url)
      
      html_string = allhtml.body()
      

      
      
      doc = Nokogiri::HTML(html_string)      
      
      blacklist = ['a', 'script', 'style']
      nodelist = doc.search('//text()')
      blacklist.each do |tag|
        nodelist -= doc.search('//' + tag + '/text()')
      end
      nodelist.text
      


        conn = Solr::Connection.new('http://127.0.0.1:8982/solr', :autocommit => :on)
        
         logged_user = UserSession.find.user

           userid = logged_user.id
        
        author = userid
        
        
        conn.add(:id => id, :title => title, :tags => tagtext, :author => author, :url => url, :textbody => nodelist.text, :tagscommas=> tags)

        if (redirect_to_project=='true')
            
        else 
     redirect_to :controller => :"/myresearch"
   end

   end
  
  
end