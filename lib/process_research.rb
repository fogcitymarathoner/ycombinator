module ProcessResearch
  
  require 'solr'

   require 'rubygems'
   require 'open-uri'
   require 'mechanize'

    require 'uri'
   require 'will_paginate'
  

def create_research(userid, research_item, links, tags)
  
  dialogue_id = '1'
  
    research_item.title = links.title;
    research_item.url = links.url;
    
    research_item.created_by = userid;
    
    
      
       $mech = Mechanize::Mechanize.new

       url = links.url
       puts 'URL: '+url.to_s
       allhtml = $mech.get(url)

       html_string = allhtml.body()


       linkdoc = Nokogiri::HTML(html_string)

       rsslink = ''
       
       
       
        linkdoc.xpath('//link[@rel="alternate"]').each do |link|
          rsslinktemp = link['href']
          rsstype = link['type']
          

          
          if (rsstype!=nil)
                puts 'RSS Type: '+rsstype
                        
                if ((rsstype.index('rss')!=nil)||(rsstype.index('atom')!=nil)||(rsstype.index('xml')!=nil&&rsstype.index('rdf')==nil))
                    
                      if ((rsslinktemp.index('feed'))!=nil&&(rsslinktemp.index('comment')==nil))
                            if (rsslink=='')
                              rsslink = rsslinktemp
                            elsif (rsslinktemp.length<rsslink.length)
                              rsslink = rsslinktemp
                            end
                
                          else
                            puts 'index of rsslinktemp was indeed null'
                            rsslink = rsslinktemp;
                          end

          
                        end
                        
                        puts ('result as this stage' +rsslink)
       


                if (rsslink!='')
         
                    if ((rsslink.starts_with?'http')==false)

                        u = URI.parse(url)

                          rsslink = 'http://'+u.host+rsslink
                        end
           
               
                        research_item.rssurl = rsslink

                      end
            end
     end
      
      

    
    title = links.title
    
    if (title=='')
      title = 'None'
    end

    ResearchItem.transaction do
      research_item.save!
      
        text = tags.tagtext;
        
        puts 'This is the tag text: '+text

        textarray = text.split(',');
        
      newtags = []
      
      for t in textarray
        if t.include? "project:"
          @temptag = Tag.find(:first, :conditions => ["tagtext = ?" , t])
          unless @temptag.nil?
            newtags << @temptag
            next
          end
        end
         @newtag = Tag.new
         @newtag.research_item_id = @research_item.id;
         
         stripped = t.gsub(%r{</?[^>]+?>}, '')
         stripped = stripped.strip
         @newtag.tagtext = stripped.downcase;
         @newtag.created_by = userid;
         @newtag.save!
         newtags << @newtag
       end
       
       for tag in newtags
         
         @retag = ResearchTagAssociation.new
         @retag.research_id = @research_item.id
         @retag.tag_id = tag.id
         @retag.save!
         
       end
       
       already_associated = []
       
       for tag in newtags
         puts 'Newtag id'+ tag.id.to_s + ' : '+tag.tagtext
         
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
       
      
     links.research_item_id = research_item.id;
     links.save!
    
     
  #  render :controller => :"search/index", :action => :indexU
  #   redirect_to :controller => :"search/index", :action => :indexURL, :params => {:link => links.url, :researchid =>research_item.id, :tags =>tags.tagtext, :title =>title, :redirect_to_project => 'true'}, :layout => 'false'
     indexURL(links.url, research_item.id, tags.tagtext, 'true', title )
     #redirect_to :action => :list
   end
   
 rescue ActiveRecord::RecordInvalid => e
   @tags.valid?
   
 end


      def getTheTitle(url)



         $mech = WWW::Mechanize.new

         title = $mech.get(url).title()

        return title


      end


   def indexURL(link, researchid, tagsParam, redirect_to_projectParam, titleParam)

     url = link

     id = researchid

     tags = tagsParam

     redirect_to_project = redirect_to_projectParam

     if (redirect_to_project.nil?)
       redirect_to_project = 'false';
     end

     textarray = tags.split(',');

     tagtext = ''
     for t in textarray
        tagtext = tagtext+' '+t
      end

     title = titleParam



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



      # conn = Solr::Connection.new('http://127.0.0.1:8090/solr', :autocommit => :on)
       conn = Solr::Connection.new('http://127.0.0.1:8982/solr', :autocommit => :on)

         logged_user = UserSession.find.user

           userid = logged_user.id

        author = userid
       
        conn.add(:id => id, :title => title, :tags => tagtext, :author => author, :url => url, :textbody => nodelist.text, :tagscommas=> tags)
    #   conn.add(:id => id, :title => title, :tags => tagtext, :author => author, :url => url, :textbody => "<html></html>", :tagscommas=> tags)
        if (redirect_to_project=='true')

        else

        end

   end


end

