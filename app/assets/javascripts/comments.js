$(document).ready(function(){
  $('.add-comment-link').click(function(e) {
    e.preventDefault();
    $(this).hide();
    object_id = $(this).data('id');
    $('form#comment-' + object_id).show();
  });

    $('.save-comment').click(function(e) {
    object_id = $(this).data('id');
    $('form#comment-' + object_id).hide();
    $('.add-comment-link').show();
  });

  question_id=$(".question").data("id");
  channel = "/comments/question/"+question_id;
  PrivatePub.subscribe(channel, function(data, channel)
  {
    obj = data.message.obj
    $("."+obj.commentable_type.toLowerCase()+"-comments-"+obj.commentable_id+" ul").append("<li>"+obj.body+"</li>");
  });
});
