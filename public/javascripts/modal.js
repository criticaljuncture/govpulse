$(document).ready(function() {
  var login_target_form = $('form#login_register_modal');
  
  $('#user_sign_in_type_login').bind('change', function(e){
    e.preventDefault();
    login_target_form.attr('action', '/user_session');
    $('.modal #login .modal-box-content h3:first').html('Login');
    $('form #user_submit').attr('value', 'Login');
  });
  
  $('#user_sign_in_type_register').bind('change', function(e){
    e.preventDefault();
    login_target_form.attr('action', '/users');
    $('.modal #login .modal-box-content h3:first').html('Register');
    $('form #user_submit').attr('value', 'Register');
  });
  
  
  $(login_target_form).bind('submit', function(e){
    e.preventDefault();
    $.ajax({
      type: "POST",
      data: $(login_target_form).serialize(),
      url: $(login_target_form).attr('action'),
      success: function(result){
        eval(result);
      }
     });
    
  })
  
});