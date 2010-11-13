class Search::SController < ApplicationController



   require 'net/http'
require 'json'



 def s()
   
   
   query = params[:q]

   solr = RSolr.connect :url=>'http://127.0.0.1:8982/solr'
      
      response = solr.select({
          :q=>q, :wt=>'json'
          })
      
      
      
    #solr.select :q=>'salon'
    
    
 puts response.raw[:body]
      
     end

 def search ()
   
    logged_user = UserSession.find.user

      userid = logged_user.id
      
   
    tagsonly = params[:tagsonly]
    query = params[:q]
    
    urlquery = CGI::escape(query)
    puts 'Query: '+urlquery
    
    if (tagsonly!='true')


    h = Net::HTTP.new('127.0.0.1', 8982)
    
    boost = CGI::escape('{!boost b=recip(ms(NOW,rubydate),3.16e-11,1,1)}')
    
      solrquery = '/solr/select?hl=on&hl.fl=textbody&wt=json&q='+boost+urlquery+'&fq=author:'+userid.to_s
      
    
    puts 'SOLR: '+solrquery
    hresp, data = h.get(solrquery, nil)
    
    puts 'Response: '+ data
    
    
    
    rsp = JSON.parse(data)
    
    
    hlength = rsp['highlighting'].length
    
    highlight = rsp['highlighting']
    
    
    docs = rsp['response']
    
    
    resultshash = {}
    
    
    docs.each_pair do |k,v|
      
      if k == 'docs'
              #puts 'key: '+k
              
               v.length.times do |i|
                    dochash = v[i]
                      hashtitle  = ''
                      hashid = ''
                      hashurl = ''
                      hashtags = ''
                      
                      count = 0;
                      dochash.each_pair do |key,value |

                        #puts 'Key: '+key
                         if key == 'title'
                          #  puts 'Title: '+value
                            hashtitle = value
                          end
                        if key == 'id'
                          #puts 'ID: '+value
                          hashid = value
                          
                        end
                        if key == 'url'
                          #puts 'ID: '+value
                          hashurl = value
                          
                        end
                        
                        if key == 'tagscommas'

                          hashtags = value[0,value.length-1]

                        end
                      end
                      
                          @ResearchItem = ResearchItem.find(:all, :conditions =>"id='"+hashid+"'")[0]
                         
                               @ritagids = ResearchTagAssociation.find(:all, :conditions =>"research_id='"+hashid+"'")

                               ids = []
                               @ritagids.each do |r|
                                 ids << r.tag_id
                               end

                               puts ids

                               @ResearchItemTags = Tag.find(:all, :conditions => ["id in(?)", ids] )
                              

                         alltags = []

                         @ResearchItemTags.each do |ri|

                           alltags << ri.tagtext

                         end
                      
                        premerge0 = {:id =>hashid}
                        premerge1 = {:title => hashtitle}
                        premerge2 = {:url =>hashurl}
                        premerge3 = {:tags =>alltags}
                        premerge4 = {:query =>query}
                        premerge5 = {:rssurl =>@ResearchItem.rssurl}
                        premerged = premerge1.merge!(premerge0)
                        premerged = premerged.merge!(premerge1)
                        premerged = premerged.merge!(premerge2)
                        premerged = premerged.merge!(premerge3)
                        premerged = premerged.merge!(premerge4)
                        premerged = premerged.merge!(premerge5)
                        resultshash[hashid] = premerged
                    
                       count = count + 1;
                    
                end
            end
    end
    
   # puts resultshash
    
    
    highlight.each_pair do |k,v|
    
        v.each_pair do |key,value |
          
          value.length.times do |i|
                
                #puts 'existing: '+resultshash[k].to_s
                mergehash = resultshash[k]
                

                newmerge = {:snippet => value[i]}
                
                
                merged = mergehash.merge!(newmerge)
                resultshash[k] = merged
                #puts 'KEY: '+k.to_s + " " + value[i]
            
          end
      end
    end
    
    
    
    @results = resultshash
   
    

    
    
 else
   
   
    resultshash = {}
    
   @tags = Tag.find(:all, :conditions => ["tagtext like ?", '%'+query+'%'])
  
   @tags.each do |t|
     
     #puts 'Result: '+t.tagtext;
     @ResearchItem = ResearchItem.find(t.research_item_id)
     
    
     
     @ResearchItemTags = Tag.find(:all, :conditions =>"research_item_id='"+@ResearchItem.id.to_s+"'")
     
     alltags = []
     
     @ResearchItemTags.each do |ri|
       
       alltags << ri.tagtext
       
     end
     
       premerge0 = {:id =>@ResearchItem.id}
       premerge1 = {:title => @ResearchItem.title}
       premerge2 = {:url =>@ResearchItem.url}
       premerge3 = {:tags => alltags }
       premerge4 = {:query =>query}
       premerge5 = {:rssurl =>@ResearchItem.rssurl}
       
       premerged = premerge1.merge!(premerge0)
       premerged = premerged.merge!(premerge1)
       premerged = premerged.merge!(premerge2)
       premerged = premerged.merge!(premerge3)
       premerged = premerged.merge!(premerge4)
       premerged = premerged.merge!(premerge5)
       
       resultshash[@ResearchItem.id] = premerged
     
       
   end
  
   @results = resultshash
  end   
   
end


end