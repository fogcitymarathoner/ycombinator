// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


jQuery.noConflict();



  function alertForm() {
    
    
   
    
    
     var mainvalue = document.getElementById("tags_tagtext").value;
    
    
     var noncreatedvalue = document.getElementById("hiddentextinput").value

 	//alert(document.getElementById("tags_tagtext").value);
    
       var newmainvalue = mainvalue + noncreatedvalue;
       document.getElementById("tags_tagtext").value = newmainvalue;
  }

function submitenter(myfield,e)
{
var keycode;
if (window.event) keycode = window.event.keyCode;
else if (e) keycode = e.which;
else return true;

if (keycode == 13)
   {
     submitsearchform();
   return false;
   }
else
   return true;
}


function confirmTag(query,id) {
  
  
  if (confirm('Are you sure you want to tag this with the search term: "'+query+'" ?')) {
    

      var url =  '/research_item/add_tag_to_research?tagtext='+escape(query)+'&researchid='+id;   
    
      
    jQuery.ajax({
      

        type: "POST", url: url, data: "", success: function(data){

           	

            }
        })
        
    
    
    
    
  }
  location.reload(true);
  
}

function submittagsearch(tagtext) {
	
	
	
	
       document.getElementById('tagquerytext').innerHTML = tagtext;
	
	try {

		
			document.getElementById('createresearchform').innerHTML = ''
	} catch (err) {
		
		
		
	}

	
	submitsearchform();
	
	
}



function submitsearchform()
{
	
	var data = '';

try {
  	data = document.myform.q.value;
} catch (err) {
	
	
}

	if (data==''||data=='Search Research by Keyword') {
	
	data = document.getElementById('tagquerytext').innerHTML;
	

	

	
	}

if (data=='')  {
	
	location.reload(true);
  
	
	
}
else {

  jQuery.ajax({ 
    type: "POST",  
    url: "/search/s/search?q="+data,
    data: data,  
    success: function(result) { 

      var elem = document.getElementById('searchlistview');
	elem.innerHTML = result;
	try {
		var searchelem = document.getElementById('searchview');
		searchelem.style.display='block';
	} catch (err) {
		
	}
      



    }  
  });

 jQuery.ajax({ 
    type: "POST",  
    url: "/searchtag?q="+data,  
    data: data,  
    success: function(newresult) { 

      var elem = document.getElementById('lefttagnav');

      	elem.innerHTML = newresult;


    }  
  });

}

}



jQuery(document).ready( function(){
	
	
	var $j = jQuery.noConflict();
 
	
	 

	

	$j("#research_checkbox").click(function() {
		$.ajax({
		    url: '/research_item/partial',
		    type: 'GET',
		    timeout: 1000,
		    error: function(){
		        alert('Error loading research');
		    },
		    success: function(data){
				addResearch(data);
				
				
		    }
		});
		
		
	  
	});
	
	 $j("#tags_tagtext").tokenInput("/tags.json", { hintText: "Start typing some concepts", canCreate: true,

	classes: {
	tokenList: "token-input-list-facebook",
	token: "token-input-token-facebook",
	tokenDelete: "token-input-delete-token-facebook",
	selectedToken: "token-input-selected-token-facebook",
	highlightedToken: "token-input-highlighted-token-facebook",
	dropdown: "token-input-dropdown-facebook",
	dropdownItem: "token-input-dropdown-item-facebook",
	dropdownItem2: "token-input-dropdown-item2-facebook",
	selectedDropdownItem: "token-input-selected-dropdown-item-facebook",
	inputToken: "token-input-input-token-facebook"
	}



	});
	
	
		// initialize tooltip



 

});

function constructTagInput(unique) {
	
	var $j = jQuery.noConflict();
 
	
	 $j("#tags_tagtext"+unique).tokenInput("/tags.json", { hintText: "Start typing some concepts", canCreate: true,

	classes: {
	tokenList: "token-input-list-facebook",
	token: "token-input-token-facebook",
	tokenDelete: "token-input-delete-token-facebook",
	selectedToken: "token-input-selected-token-facebook",
	highlightedToken: "token-input-highlighted-token-facebook",
	dropdown: "token-input-dropdown-facebook",
	dropdownItem: "token-input-dropdown-item-facebook",
	dropdownItem2: "token-input-dropdown-item2-facebook",
	selectedDropdownItem: "token-input-selected-dropdown-item-facebook",
	inputToken: "token-input-input-token-facebook"
	}



	});
	
	
}


function initTags() {
 jQuery("#tags_tagtext").tokenInput("/tags.json", { hintText: "Start typing some concepts", canCreate: true,

classes: {
tokenList: "token-input-list-facebook",
token: "token-input-token-facebook",
tokenDelete: "token-input-delete-token-facebook",
selectedToken: "token-input-selected-token-facebook",
highlightedToken: "token-input-highlighted-token-facebook",
dropdown: "token-input-dropdown-facebook",
dropdownItem: "token-input-dropdown-item-facebook",
dropdownItem2: "token-input-dropdown-item2-facebook",
selectedDropdownItem: "token-input-selected-dropdown-item-facebook",
inputToken: "token-input-input-token-facebook"
}

});
}




   function evaluateUrl(content) {
      
      
      var matches = [];
    
  	      var url_match = /https?:\/\/([-\w\.]+)+(:\d+)?(\/([\w/_\.]*(\?\S+)?)?)?/;

         if (url_match.test(content)) {
           
            
           
         }
       //	alert(url_match.test(content));   
      
    }
    
    function getTags() {
      


     var values =  document.getElementById('tags_tagtext').value;
     
    // alert('values: '+values);
      
    }


    
    function getUrl() {
	


      var content = document.getElementById("link_url").value;

      
      jQuery.ajax({ url: "/title.js?url="+encodeURI(content), context: document.body, success: function(data) {

        updateTitle(data);
       
      }
    });
    
    }
    
    
    function updateTitle(message) {
      
	

     if (document.getElementById('link_title').value=='') {
      document.getElementById('link_title').value=message;
		}
      
      
    }
    
    function matchUrl() {
      
      var input_content = "blah \
      http://www.techweb.com blah\ http://google.com lasdkjfas\
        <a href=\"http://yahoo.com\">Yahoo</a> \
        blah \
        <a href=\"http://google.com\">Google</a> \
        blah";
        
    var content = document.getElementById("research_item_body").value;

    var matches = [];

    content.replace(/https?:\/\/[\w*|.]*[\s|\W|\0]*/g, function () {
        matches.push(Array.prototype.slice.call(arguments, 0, 1));
    });

    alert(matches.join("\n"));
    
      
      
    }







     // to set WMD's options programatically, define a "wmd_options" object with whatever settings
     // you want to override.  Here are the defaults:
wmd_options = {
             // format sent to the server.  Use "Markdown" to return the markdown source.
             output: "HTML",

             // line wrapping length for lists, blockquotes, etc.
             lineLength: 40,

             // toolbar buttons.  Undo and redo get appended automatically.
             buttons: "bold italic | link blockquote code image | ol ul heading",

             // option to automatically add WMD to the first textarea found.  See apiExample.html for usage.
             autostart: false
			
     };
	 

})

