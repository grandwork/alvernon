$(document).ready(function() {
 
	// store url for current page as global variable
	current_page = document.location.href

// apply selected states depending on current page
	if (current_page.match(/qualifications/)) {
  	$("li#quals").addClass('active');
	} else if (current_page.match(/updates/)) {
   	$("li#updates").addClass('active');
  } else if (current_page.match(/admin\/admins/)) {
   	$("dd#manage_admin, li#users").addClass('active');
  } else if (current_page.match(/admin\/technicians/)) {
   	$("dd#manage_technicians, li#users").addClass('active');
  } else if (current_page.match(/admin\/pending/)) {
    $("dd#manage_pending, li#users").addClass('active');  
  } else if (current_page.match(/admin\/suspended/)) {
    $("dd#manage_suspended, li#users").addClass('active');  
  } else if (current_page.match(/admin\/clients/)) {
   	$("dd#manage_clients, li#users").addClass('active');
  } else if (current_page.match(/clients/)) {
    $("dd#manage_clients, li#clients").addClass('active');  
	};
});


	
	