	
function escapeString(s){
    if (s==null) return ''
    var replaceRegex = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&#34;',
        "'": '&#39;'
    };
    var repl = function(c){
        return replaceRegex[c];
    };
		 
    return s.replace(/[&<>'"]/g, repl);
}
	
	
function loadXMLString(txt){

    parser = new DOMParser();
    xmlDoc = parser.parseFromString(txt, "text/xml");
    return (xmlDoc);
          
}

/**
       * Convert links in text into hyperlinks
       * @param {Object} theString
       */
function format(theString){
    var tokens = theString.split(" ");
    var result = "";
    for (var i = 0; i < tokens.length; i++) {
        var firstFour = tokens[i].substring(0, 7);
        var firstThree = tokens[i].substring(0, 4);
        if (firstFour == "http://")
            result += '<a href=\"' + tokens[i] + '\" target=\"_new\">' + tokens[i] + '</a> ';
        else
        if (firstThree == 'www.')
            result += '<a href=\"htt' + tokens[i] + '\" target=\"_new\">' + tokens[i] + '</a> ';
        else
            result += tokens[i] + ' ';
    }
    return result;
}

function getNodeCDATA(element)
{


    var ie = (typeof window.ActiveXObject != 'undefined');
    var returnText;

    if(ie){


        if(element.hasChildNodes){
				
            returnText = element.childNodes[0].textContent;
        }
    }
    else{
        if (element!=null) {
            if(element.hasChildNodes){
			
                try {
                    returnText = element.childNodes[0].nodeValue;
                } catch (err) {
                    returnText = 'unavailable'
				
                }
				
            }


        }
    }
		
    return returnText;

		
		
}
	

function getRSSFeed(rssurl,id) {
         
    jQuery.noConflict();
			
    var setid = document.getElementById("scrollerid");
    setid.innerHTML= id;
					

    jQuery('loader'+id).innerHTML = "<img src=\"/images/ajax-loader.gif\" />";
    var xmlHttp3 = new XMLHttpRequest();
    xmlHttp3.onreadystatechange = function(){

        if (xmlHttp3.readyState == 4) {
                          
            jQuery('loader'+id).innerHTML = "";
    
            var xmlAdd = new String('<?xml version="1.0" encoding="UTF-8"?><thread>');
            var commentXMLDoc = loadXMLString(xmlHttp3.responseText);

            var xmlObj = commentXMLDoc.documentElement;
				

            //alert(xmlObj.textContent);
            commentsArray = xmlObj.getElementsByTagName("item");
            var isAtom = false;


            if (commentsArray.length==0) {
																		
                //	alert('its atom');

                commentsArray = xmlObj.getElementsByTagName("entry");
                isAtom = true;

    			                                        
            }
            else {
            //alert ('its rss'+commentsArray.length);
															
            }

            var rows = commentsArray.length;
            var xmlAdd = "<?xml version='1.0' encoding='utf-8'?>";
            xmlAdd += "<response>";
            xmlAdd += "<row><numRows>" + rows + "</numRows></row>";

            for (var i = 0; i < commentsArray.length; i++) {
                var title = commentsArray[i].getElementsByTagName("title")[0].firstChild.data;
                var origLink = 'http://www.google.com';
                if (isAtom==false) {
	
																		
                    //                                				origLink = commentsArray[i].getElementsByTagName("link")[0].firstChild.data;
                    try {
                        origLink = commentsArray[i].getElementsByTagName("link")[0].firstChild.data;
                    } catch (err) {
												
                        origLink = commentsArray[i].getElementsByTagName("link")[1].firstChild.data;
                    }
												

                                				
                }
                else {
                            
	
                    theParagraph = commentsArray[i].getElementsByTagName("link")[0];
                              
                    for( var x = 0; x < theParagraph.attributes.length; x++ ) {
                        if( theParagraph.attributes[x].nodeName.toLowerCase() == 'href' ) {
                                 
                            origLink = theParagraph.attributes[x].nodeValue ;
                        }
                    }
                              

                              
                }
                var desc = ''
                if (isAtom==false) {
	

                    elem = commentsArray[i].getElementsByTagName("description")[0];
									
                    //alert(getCDATA(elem));
									
                    desc = getNodeCDATA(elem);
									
									
								
									
                } else {
	
                    try {
                        desc = commentsArray[i].getElementsByTagName("summary")[0].firstChild.data;
                    } catch (err) {
                        try {
                            desc = commentsArray[i].getElementsByTagName("content")[0].firstChild.data;
                        } catch (suberr) {
                            desc = 'unavailable';
									
                        }

                    }

                }
                var link = origLink;
                // Format hyperlinks
                link = format(link);
                // Escape single quotes, double quotes, and new lines
                link = escapeString(link);

                // Add a new XML entry

                var tempXml = '';
                                
                tempXml += "<row>";
                tempXml += "<commentId>0</commentId>";
                tempXml += "<replyTo>Blank for now</replyTo>";
                tempXml += "<numReplies>0</numReplies>";
                tempXml += "<commentDate>" + escapeString(title) + "</commentDate>";
                tempXml += "<authorName>Blah</authorName>";
                tempXml += "<numDiggs>0</numDiggs>";
                var newLink = "<a href=\""+origLink+"\">"+title+"</a>";
    			    
    			    
                newLink = escapeString(newLink);

                desc = escapeString(desc);

                                
                tempXml += "<commentBody>"+ newLink + " : "+desc+ "</commentBody>";
                // <a href="link">title</a>
                tempXml += "</row>";
                xmlAdd += tempXml;
            }
            // Close the XML string
            xmlAdd += "</response>";

            var s = new scroller(id);
            s.draw();
            s.contentReady(xmlAdd);

            var imgLoader = document.getElementById('img_loader');
            if(imgLoader) {
//                alert('remove img');
                imgLoader.parentNode.removeChild(imgLoader);
            }
        }
    }



    //  var myURL = document.getElementById('url').value;
    var actualurl = escape(rssurl);



    var total = "/simple_proxy/geturl?url=" + actualurl;

    xmlHttp3.open("GET", total, true);
    xmlHttp3.send(null);


}