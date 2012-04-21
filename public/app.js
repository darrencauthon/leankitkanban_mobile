$(document).bind("mobileinit", function(){
  $.mobile.ajaxEnabled = false;
  alert('k');
});
$(document).ready(function(){
  $('#login_button').attr('onclick', "$('form').submit()");
});
