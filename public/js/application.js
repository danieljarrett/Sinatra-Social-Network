// clean up this and the element caller to jquery

function submitenter(myfield, e) {
	var keycode;
	if (window.event) keycode = window.event.keyCode;
	else if (e) keycode = e.which;
	else return true;
	if (keycode == 13) {
	   myfield.form.submit();
	   return false;
	}
	else {
	  return true;
	}
}

// activate buttons

function activate() {
	if (window.location.pathname == '/') {
		$('#nav1').addClass('active')
	}
	else if (window.location.pathname == '/profile') {
		$('#nav2').addClass('active')
	}
	else if (window.location.pathname == '/friends') {
		$('#nav3').addClass('active')
	}
	else if (window.location.pathname.match('mailbox')) {
		$('#nav4').addClass('active')
	}
}

// sneak

var ScrollSneak = function(prefix, wait) {
  
  // clean up arguments (allows prefix to be optional - a bit of overkill)
  
  if (typeof(wait) == 'undefined' && prefix === true) {
  	prefix = null;
  	wait = true;
  }
  
  prefix = (typeof(prefix) == 'string' ? prefix : window.location.host).split('_').join('');
  
  var pre_name;

  // scroll function, if window.name matches, then scroll to that position and clean up window.name
  
  this.scroll = function() {
	  if (window.name.search('^'+prefix+'_(\\d+)_(\\d+)_') == 0) {
      var name = window.name.split('_');
      if (document.referrer == document.URL) {
      	window.scrollTo(name[1], name[2]);
      }
      window.name = name.slice(3).join('_');
	  }
  }

	// if not wait, scroll immediately

	if (!wait) this.scroll();

  this.sneak = function() {
	
		// prevent multiple clicks from getting stored on window.name
	
		if (typeof(pre_name) == 'undefined') pre_name = window.name;

		// get the scroll positions
    
    var top = 0, left = 0;
    
    if (typeof(window.pageYOffset) == 'number') { // netscape
        top = window.pageYOffset, left = window.pageXOffset;
    } else if (document.body && (document.body.scrollLeft || document.body.scrollTop)) { // dom
        top = document.body.scrollTop, left = document.body.scrollLeft;
    } else if (document.documentElement && (document.documentElement.scrollLeft || document.documentElement.scrollTop)) { // ie6
      	top = document.documentElement.scrollTop, left = document.documentElement.scrollLeft;
    }

		// store the scroll
      
    if (top || left) window.name = prefix + '_' + left + '_' + top + '_' + pre_name;
    
    return true;

  }
}

// ready

$(document).ready(function() {

	// activate();

	(function() {
    var sneaky = new ScrollSneak(location.hostname);
    var all = document.getElementsByTagName('*');
    for (var i = 0; i < all.length; i++) {
    	// all[i].onClick( function() { alert("lol"); };
    	all[i].onclick = sneaky.sneak;
		};
	})();

});