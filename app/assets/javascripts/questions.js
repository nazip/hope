$(document).ready(function(){

  $('.edit-question-link').click(function(e) {
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('form#edit-question-' + question_id).show();
  });

  channel = "/questions";
  PrivatePub.subscribe( channel, function(data, channel)
  {
    $(".questions").append(data.message.obj);
  });

});
