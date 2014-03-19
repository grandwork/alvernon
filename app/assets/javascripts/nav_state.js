$(document).ready(function() {
 
	// store url for current page as global variable
	current_page = document.location.href

// apply selected states depending on current page
	if (current_page.match(/admin\/admins/)) {
		$("#manage_admin").addClass('active');
	} else if (current_page.match(/admin\/clients/)) {
		$("li#manage_clients").addClass('active');
	} else if (current_page.match(/admin\/technicians/)) {
  	$("#manage_technicians").addClass('active');
  } else if (current_page.match(/admin\/suspended/)) {
  	$("li#manage_suspended").addClass('active');	
	} else if (current_page.match(/admin\/pending/)) {
		$("li#manage_pending").addClass('active');
	};
});
