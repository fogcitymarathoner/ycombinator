class SimpleProxyController < ApplicationController
  
  
  require 'mechanize'
  require 'sanitize'
  require 'cgi'
  
  require 'feedzirra'
  require 'nokogiri'
  require 'hpricot'
  
#  class Atom; element :description; end
 #  class RSS; element :description; end
#   class AtomFeedBurner; element :description; end
  
  def geturlfeed
    
 
    
       url = params[:url]
        
    feed = Feedzirra::Feed.fetch_and_parse(url)
    
    html = '<?xml version="1.0" encoding="UTF-8" ?><rss version="2.0"><channel>'
    
    
    feed.entries.each do |entry|
    
    
    #{entry.summary}\n\n"
    html << "<item><br/><br/>"
    
    unless entry.title.nil?
    html << "<title>#{entry.title.sanitize}</title>"
  end
    unless entry.url.nil?
    html << "<link>#{entry.url.sanitize}</link>"
  end
    unless entry.summary.nil?
      html << "<description>#{entry.summary.sanitize}</description>"
    end

     unless (entry.content.nil?)
       html << "<description>#{entry.content.sanitize}</description>"
     end
     
    html << "</item>"
    end
    
    html << '</channel></rss>'
    

    newhtml = sanitize_fu(html)
    
    puts newhtml
    
    render :text => newhtml
   
    
  end


  def geturltest
    
        url = params[:url]
        
    feed = Feedzirra::Feed.fetch_and_parse(url)
    
    html = '<?xml version="1.0" encoding="UTF-8" ?><rss version="2.0"><channel>'
    
    html << "<title>Title of an item</title>
    <link>http://example.com/item/123</link>
    <guid>http://example.com/item/123</guid>
    <pubDate>Mon, 12 Sep 2005 18:37:00 GMT</pubDate>"
    
    feed.entries.each do |entry|
    
    
    #{entry.summary}\n\n"
    html << "<item><br/><br/>"
    html << "<title>#{entry.title.sanitize}</title>"

    html << "<link>#{entry.url.sanitize}</link>"
    
    html << "<description>#{entry.summary.sanitize}</description>"
    
    html << "</item>"
    end
    
    html << '</channel></rss>'
    
    
    newhtml = Nokogiri::XML::DocumentFragment.parse(html)
    
    puts newhtml
    
    render :text => newhtml
    
    
  end
  
  def geturl
    
     url = params[:url]

      unurl = CGI::unescape(url)

      $mech = WWW::Mechanize.new

      allhtml = $mech.get(unurl)

      html_string = allhtml.body()

              #render error if result. ...



  #      xml = Nokogiri::XML.parse(html_string)


      
      
       #puts html_string


       puts html_string
    


              render :text => html_string
    
    
  end
  
  def getplainurl
    
    url = params[:url]
    
    unurl = CGI::unescape(url)
  
    $mech = WWW::Mechanize.new
    
    allhtml = $mech.get(unurl)
    
    html_string = allhtml.body()

            #render error if result. ...
            

        
#      xml = Nokogiri::XML.parse(html_string)
        
        
      escaped =  CGI::unescapeHTML(html_string)
      
       sanitized = sanitize_fu(escaped)
       
       double  = sanitized.gsub("&nbsp;", "")
       double  = double.gsub("&rarr;", "")
      double  = double.gsub("&rsquo;", "\'")
      double  = double.gsub("&ldquo;", "")
      double  = double.gsub("&rdquo;", "")
      double  = double.gsub("&ndash;", "")      
      double  = double.gsub("&lsquo;", "")      
double  = double.gsub("&mdash;", "")
double  = double.gsub("&raquo;", "")    
double  = double.gsub("&...", "")
double  = double.gsub("&#187;", "")
double  = double.gsub("&#8212;", "")

double =  double.gsub(/\[.*\]/, "")

double = double.gsub("&pound;", "#")


     test = "hem. [<em>iPad  only</em> - <a>iTunes  link</a>]</p><br />Color"
     


     #puts html_string
     
     sanitized = sanitize_fu(double)



      puts sanitized

            

            render :text => sanitized
                  
  
  end
  
  def format_user_text(input)
      output = "<p>#{input.strip}</p>"

      # do some formatting
      output.gsub!(/\r\n/, "\n")       # remove CRLFs
      output.gsub!(/^$\s*/m, "\n")     # remove blank lins
      output.gsub!(/\n{3,}/, "\n\n")   # replace \n\n\n... with \n\n
      output.gsub!(/\n\n/, '</p><p>')  # embed stuff in paragraphs
      output.gsub!(/\n/, '<br/>')      # nl2br

      sanitize_fu output
    end

    # Adapted from http://ideoplex.com/id/1138/sanitize-html-in-ruby
    def sanitize_fu(html, okTags = 'a href, updated, atom10, generator,summary, content, category,author, subtitle,href, b, br, p, i, em, id,name,  img, link,description, dc, textinput, rdf, slash, feedburner, rss, atom, media, feedburner, channel, pubdate, title,  item, guid')
      # no closing tag necessary for these
      soloTags = ["br","hr"]

      # Build hash of allowed tags with allowed attributes
      tags = okTags.downcase().split(',').collect!{ |s| s.split(' ') }
      allowed = Hash.new
      tags.each do |s|
        key = s.shift
        allowed[key] = s
      end

      # Analyze all <> elements
      stack = Array.new
      result = html.gsub( /(<.*?>)/m ) do | element |
        if element =~ /\A<\/(\w+)/ then
          # </tag>
          tag = $1.downcase
          if allowed.include?(tag) && stack.include?(tag) then
            # If allowed and on the stack
            # Then pop down the stack
            top = stack.pop
            out = "</#{top}>"
            until top == tag do
              top = stack.pop
              out << "</#{top}>"
            end
            out
          end
        elsif element =~ /\A<(\w+)\s*\/>/
          # <tag />
          tag = $1.downcase
          if allowed.include?(tag) then
            "<#{tag} />"
          end
        elsif element =~ /\A<(\w+)/ then
          # <tag ...>
          tag = $1.downcase
          if allowed.include?(tag) then
            if ! soloTags.include?(tag) then
              stack.push(tag)
            end
            if allowed[tag].length == 0 then
              # no allowed attributes
              "<#{tag}>"
            else
              # allowed attributes?
              out = "<#{tag}"
              while ( $' =~ /(\w+)=("[^"]+")/ )
                attr = $1.downcase
                valu = $2
                if allowed[tag].include?(attr) then
                  out << " #{attr}=#{valu}"
                end
              end
              out << ">"
            end
          end
        end
      end

      # eat up unmatched leading >
      while result.sub!(/\A([^<]*)>/m) { $1 } do end

      # eat up unmatched trailing <
      while result.sub!(/<([^>]*)\Z/m) { $1 } do end

      # clean up the stack
      if stack.length > 0 then
        result << "</#{stack.reverse.join('></')}>"
      end

      result
    end

    def  load_modal_rss
      @rssurl = params[:url]
      
      @rssid = params[:id]
      
    end
  
  
end
