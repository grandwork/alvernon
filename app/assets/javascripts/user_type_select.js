$('#user_role').change(function(){
   selection = $(this).val();    
   switch(selection)
   { 
       case 'Client':
           $('#client_select').show();
           $('#user_client_id').removeAttr("disabled");
           $('#user_email').removeAttr("disabled");
           $('#user_email').attr('placeholder', 'Enter the client email address');
           break;
       default: 'Technician'
           $('#client_select').hide();
           $('#user_client_id').attr('disabled', true);
           $('#user_email').removeAttr("disabled");
           $('#user_email').attr('placeholder', 'The technician must have a @csindi.com email address');
           break;
   }
});