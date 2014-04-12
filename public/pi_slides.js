var autosubmit = function(){
  var form = $(this).parents('form');
  var name = $(this).attr('name');
  $(form).find('input[name=user_action]').attr('value', name);
  $(form).submit();
};

$(document).on('change', 'form select[name=autoplay]', autosubmit);
$(document).on('slidestop', 'form input[name=interval]', autosubmit);

