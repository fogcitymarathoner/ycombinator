/*
 Scroller
 Scroller is a js comment browser built on the prototype framework.
 Note that prototype framework is different from the prototype method
 which is also used here.  The prototype framework offers Class.create,
 new Element, and Event.observe among others.  The prototype method,
 is used to add methods / properties to a js object, this is utilized as
 object.prototype.method = function ()
 Draws a browser, loads content from the web service proxy.  Replies are
 loaded as new instances of the browser represented as a virtual tree,
 the tree is implemented by adjacency model.
 */
var scroller = Class.create();

/**
 scroller::initialize (object)
 @param parentScroller Object
 
 Sets the default properties of the scroller object
 This method is broken currently, will not properly allow for multiple expanded branches.
 a new way of handling parentScroller is needed.
 */
scroller.prototype.initialize = function(parentScroller){
    if (typeof parentScroller == "undefined") {
        this.id = 0;
    } else if(typeof parentScroller == 'number') {
        this.id = parentScroller;
    }
    else {
        this.parentScroller = parentScroller;
        this.id = parentScroller.id++;
    }

    this.scrollTime = 100;
    
    this.currentTop = 0;
    
    this.domId = "scrollerId_" + this.id;
    
    this.commentId = 0;
    this.divHeights = [];
    this.scrollUpCount = 0;
    this.scrollDownCount = 0;
    
    
    this.contentHeight = 0;
    
    //this.loadContent();
};

scroller.prototype.setParentDiv = function(parentDiv) {
   

};

/**
 scroller::draw ()
 Draws the scroller to the page.
 */
scroller.prototype.draw = function(){
	
	

    // No magic numbers, yay!!
    
    var that = Object.clone(this);
    var scrollInterval;
    var self = this;
    
    var div = new Element("div", {
        'id': that.domId,
        'class': 'scrollContainer'
    });
    
    if (this.id > 0) {
        var connector = new Element("div", {
            'id': that.domId + "_connector",
            'class': 'scrollConnector'
        });
        
        div.insert(connector);
    };
    
    var scroller = new Element("div", {
        'id': that.domId + "_scroller",
        'class': 'scroller'
    });
    
    var topRow = new Element("div", {
        'class': 'scrollerTopRow'
    });
    
    
    var topLeftCorner = new Element("div", {
        'class': 'scrollerTopLeftCorner'
    });
    
    var topMiddle = new Element("div", {
        'class': 'scrollerTopMiddle'
    });
    
    var scrollUp = new Element("img", {
        'src': '/images/scrollUp.jpg',
        'style': 'margin-left: 257px;'
    });
    
    var pageUp = new Element("img", {
        'src': '/images/pageUp.jpg',
        'style': 'margin-left: 20px;'
    });
    
    Event.observe(scrollUp, "mouseover", function(e){
        // scroll up (-1)
        scrollInterval = setInterval(Function.bundle(self, "scroll", -1), 100);
    });
    
    Event.observe(scrollUp, "mouseout", function(e){
        // stop scrolling
        clearInterval(scrollInterval);
    });
    
    Event.observe(pageUp, "mousedown", function(e){
        // page up (-1)
        self.page(-1);
    });
    
    topMiddle.insert(scrollUp);
    topMiddle.insert(pageUp);
    
    var topRightCorner = new Element("div", {
        'class': 'scrollerTopRightCorner'
    });
    
    Event.observe(topRightCorner, "click", function(e){
        that.close(e);
    });
    
    topRow.insert(topLeftCorner);
    topRow.insert(topMiddle);
    topRow.insert(topRightCorner);
    
    scroller.insert(topRow);
    
    var contentHolder = new Element("div", {
        'class': 'scrollerContentHolder'
    });
    
    var content = new Element("div", {
        'id': 'scrollerContent_' + that.id,
        'class': 'scrollerContent'
    });
    
    contentHolder.insert(content);
    scroller.insert(contentHolder);
    
    var botRow = new Element("div", {
        'class': 'scrollerBotRow'
    });
    
    var botLeftCorner = new Element("div", {
        'class': 'scrollerBotLeftCorner'
    });
    
    var botMiddle = new Element("div", {
        'class': 'scrollerBotMiddle'
    });
    
    var scrollDown = new Element("img", {
        'src': '/images/scrollDown.jpg',
        'style': 'margin-left: 290px;'
    });
    
    var pageDown = new Element("img", {
        'src': '/images/pageDown.jpg',
        'style': 'margin-left: 23px;'
    });
    
    Event.observe(scrollDown, "mouseover", function(e){
        // scroll down (1)
        scrollInterval = setInterval(Function.bundle(self, "scroll", 1), 100);
        //scroll.apply(self,1);
    });
    
    Event.observe(scrollDown, "mouseout", function(e){
        // stop scrolling
        clearInterval(scrollInterval);
    });
    
    Event.observe(pageDown, "mousedown", function(e){
        // page down (1)
        self.page(1);
    });
    
    botMiddle.insert(scrollDown);
    botMiddle.insert(pageDown);
    
    var botRightCorner = new Element("div", {
        'class': 'scrollerBotRightCorner'
    });
    
    botRow.insert(botLeftCorner);
    botRow.insert(botMiddle);
    botRow.insert(botRightCorner);
    
    scroller.insert(botRow);
    
    div.insert(scroller);
    
    var body = document.body;
    
    Element.extend(body);
    
	var scrollerid = document.getElementById("scrollerid");
	
	var sid = scrollerid.innerHTML;
	
	document.getElementById("scrollercontainer"+sid).insert(div);
    //body.insert(div);
    
};

/**
 scroller::scroll (signed integer)
 @param dir signed
 Causes the browser to initiate scrolling of its content window
 -1 to begin scrolling up,
 1 to begin scrolling down,
 0 to stop scrolling
 Scrolling is handled by mouse event.
 Animation may be included at a later time to accelerate / slow scrolling
 TODO: implement method
 Example behavior:
 while mousover over the up arrow, sroller::scroll is continuously called with -1
 upon mouseout on the same arrow scroller::scroll is called with 0
 */
scroller.prototype.scroll = function(dir){

    var that = Object.clone(this);
    
    if (dir == 1) {
        var bottom = ($('scrollerContent_' + this.id).clientHeight * -1) + 383;
        if (this.currentTop > bottom) {
            // Start scrolling down
            this.currentTop -= 10;
            this.scrollDownCount += 10;
            $("scrollerContent_" + that.id).style.top = this.currentTop + "px";
        }
    }
    else 
        if (dir == -1) {
            if (this.currentTop <= -10) {
                // Start scrolling up
                this.currentTop += 10;
                this.scrollUpCount += 10;
                $("scrollerContent_" + that.id).style.top = this.currentTop + "px";
            }
        }
};

/**
 * Function to page up or down
 * @param {Object} dir -1 for up, -2 for down
 */
scroller.prototype.page = function(dir){
    var that = Object.clone(this);
    
    var lastTop = that.findNewTop();
    var soFar = 0;
    for (var i = 0; i <= lastTop; i++) {
        soFar += this.divHeights[i];
    }
    var topDifference = soFar - (this.currentTop * -1);
    
    var lastBot = that.getLastVisibleComment(lastTop, topDifference);
    
    
    //	for (var i = lastBot - 1; i >= lastTop; i--) {
    //		toScroll += this.divHeights[i];
    //}
    
    var totalHeightOfDivs = ($('scrollerContent_' + this.id).clientHeight);
    
    var bottomInvisible = totalHeightOfDivs - (383 + this.currentTop * -1);
    
    var bottomToSubtract = 0;
    for (var i = lastBot; i < this.divHeights.length; i++) {
        bottomToSubtract += this.divHeights[i];
        
    }
    
    var botDifference = bottomToSubtract - bottomInvisible;
    
    var toScrollUp = 0;
    
    for (var i = lastTop + 1; i < lastBot; i++) {
    
        toScrollUp += this.divHeights[i];
        
    }
    toScrollUp += botDifference;
    
    
    var toScrollDown = 0;
    
    for (var i = lastTop + 1; i < lastBot; i++) {
        toScrollDown += this.divHeights[i];
    }
    toScrollDown += topDifference;
    
    
    
    if (dir == 1) {
		var bottom = ($('scrollerContent_' + this.id).clientHeight * -1) + 383;
		if (this.currentTop > bottom + 383) {
			this.currentTop = this.currentTop - (toScrollDown);
		} else {
			this.currentTop = bottom;
		}
        //alert('Goin down' + this.currentTop);
        //this.currentTop = this.currentTop - toScroll;
    }
    else {
		if (this.currentTop < -383) {
			this.currentTop = this.currentTop + toScrollUp;
		//alert('Goin up' + this.currentTop);
		//this.currentTop = this.currentTop + toScroll;
		} else {
			this.currentTop = 0;
		}
    }
    $("scrollerContent_" + that.id).style.top = this.currentTop + "px";
    
};

scroller.prototype.findNewTop = function(){
    var currentHeight = 0;
    //alert(this.currentTop);
    for (var i = 0; i < this.divHeights.length; i++) {
        currentHeight += this.divHeights[i];
        //alert(currentHeight);
        
        if (currentHeight > this.currentTop * -1) {
            //	alert(document.getElementById(i).innerHTML);
            return i;
        }
    }
}

/**
 * Grabs the last visible comment in the scroller window.
 * This is a "private" function and requires the start index
 * of the first visible comment in the window. This uses the
 * divHeights array to grab the clientHeight of each div.
 */
scroller.prototype.getLastVisibleComment = function(startIndex, difference){
    var currentHeight = difference;
    var maxHeight = 383;
    var result = 0;
    
    for (var i = startIndex + 1; i < this.divHeights.length; i++) {
        currentHeight += this.divHeights[i];
        if (currentHeight > 383) {
            //alert(document.getElementById(i).innerHTML);
            result = i;
            break;
        }
    }
    //alert(result);
    return result;
};

/**
 * Method to scroll from a setInterval()
 *
 * @param {Object} context
 * @param {Object} f
 * @param {Object} args
 */
Function.bundle = function(context, f, args){
    if (typeof f == "string" && context) 
        f = context[f];
    if (arguments.length < 3) 
        args = [];
    else 
        if (!(args instanceof Array)) 
            args = Array.prototype.slice.call(arguments, 2);
    return function(){
        return f.apply(context, args);
    };
};

/**
 scroller::animate ()
 Animation may be included at a later time to accelerate / slow scrolling
 TODO: Implement method
 */
scroller.prototype.animate = function(){

};

/**
 scroller::loadContent ()
 Initiates content load to the comment browser utilizeing script injection
 the php returns generated js into the global scope.  As the last line of the returned js,
 contentReady function is called to load the data into the object, we can do this because we pass the js object
 instance name to php. note, we put an id on the script tag, so we can remove the tag later on, thus not
 polluting the head with tons of scripts.
 */
scroller.prototype.loadContent = function(){

    var that = Object.clone(this);
    
    new Ajax.Request('xml1.xml', {
        'method': 'get',
        'onSuccess': function(transport){
            that.contentReady(transport.responseXML);
        }
    });
};

/**
 scroller::contentReady ()
 Invoked by the generated js that is returned by the proxy.  The returned js syntax should
 be well formed, semicolons after every '}' . The js should also be packed with something like
 packer to remove all '\r' and '\n' characters, since js will consider these chars as statement breaks.
 A \r or \n will totaly break the js, as statement breaks cause statements to be interpreted, this will
 cause interpretation to happen prematurely also syntax errors, a \r, \n inside 'data' is interpreted
 as terminating the line of code, when it is meant to just add a new line in the data.
 packer rules this space.
 this method might need to be called with .call (ref) / .apply (ref) to preserve its scope to the object, this remains
 to be determined
 TODO: Implement method
 */
scroller.prototype.createRow = function(){
    var that = Object.clone(this);
    
    if (this.currentReplies > 0) {
        var arrow = new Element("img", {
            'src': '/images/rightArrow.png',
            'alt': 'View Replies',
            'class': 'viewReplies',
            'title': 'View Replies'
        });
        
        Event.observe(arrow, 'click', function(e){
        
        });
    }
    
    var div = new Element("div", {
        // 2 css classes:
        'class': 'baseComment commentAlter' + that.alterState,
        'id': this.commentId
    });
    this.commentId++;
    
    var commentHolder = new Element("p", {
        'class': 'commentHolder'
    }).update(this.currentComment.commentBody);
    
    //div.insert(this.currentComment.commentBody);
    div.insert(commentHolder);
    div.insert(arrow);
    
    Event.observe(div, 'click', function(e){
        var node = e.target;
        Element.extend(node)
        // other stuff, like open a new scroller if there are replies.
    });
    
    Event.observe(div, 'mouseover', function(e){
        var node = that.prepNode(e.target);
        
        if (node.hasClassName("commentAlterOn")) {
            node.toggleClassName("commentAlterOnSelected");
        }
        else 
            if (node.hasClassName("commentAlterOff")) {
                node.toggleClassName("commentAlterOffSelected");
            }
    });
    
    Event.observe(div, 'mouseout', function(e){
        var node = that.prepNode(e.target);
        
        if (node.hasClassName("commentAlterOnSelected")) {
            node.toggleClassName("commentAlterOn");
        }
        else 
            if (node.hasClassName("commentAlterOffSelected")) {
                node.toggleClassName("commentAlterOff");
            }
    });
    return div;
};

scroller.prototype.prepNode = function(node){
    Element.extend(node);
    
    return node;
};

scroller.prototype.contentReady = function(xmlString){
    parser = new DOMParser();
    var xml = parser.parseFromString(xmlString, "text/xml");

    var rows = xml.getElementsByTagName("row");

	if (rows[0]!=null) {
    var numRows = rows[0].getElementsByTagName("numRows")[0].firstChild.nodeValue;
    
    for (var i = 1; i < rows.length; i++) {
        if (i % 2) {
        
            this.alterState = "On";
        }
        else {
            this.alterState = "Off";
        }
        this.currentComment = new comment(rows[i]);
        this.currentReplies = rows[i].getElementsByTagName("numReplies")[0].firstChild.nodeValue;
        
        var newDiv = this.createRow();
        $('scrollerContent_' + this.id).insert(newDiv);
        
        //this.contentHeight += newDiv.clientHeight;
        
        this.divHeights[i - 1] = newDiv.clientHeight + 1;
        
        /*
         if (this.contentHeight / 383 > this.pageCount + 1) {
         this.pages[this.pageCount] = this.contentHeight - newDiv.clientHeight;
         this.pageCount++;
         newDiv.style.background = 'tan';
         }
         */
    }
	}
};

/**
 scroller::close ()
 Closes this specific instance of the scoller, this method may be invoked by clicking the close
 icon or by the algorithm when scroller becomes irrelivent.  This happens when another comment at the
 same level takes focus.  It remains to be determined whether a window pin will be implemented to
 override automatic close.
 */
scroller.prototype.close = function(e){
    $(this.domId).remove();
};
scroller.prototype.alert = function(e){
	alert('working');
};

var comment = Class.create();

comment.prototype.initialize = function(node){
    for (var i = 0; i < node.childNodes.length; i++) {
        if (node.childNodes[i].nodeType == 3) 
            continue;
        
        this[node.childNodes[i].nodeName] = node.childNodes[i].firstChild.nodeValue;
    }
};
