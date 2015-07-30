// $(document).ready(function () {

//   function str_const(method)
//   {
//     return  "<a data-type='json' class='like' data-remote='true' rel='nofollow' " +
//               "data-method='" + method + "' href='";
//   };
//   function get_href(q_id, a_id) {
//     if(a_id > 0)
//     {
//       return "/questions/" + q_id + "/answers/" + a_id + "/elects";
//     }
//     return "/questions/" + q_id + "/elects";
//   };

//   $('a.like')
//     .on("ajax:error", function(evt, xhr, status, error){
//       $("." + data.obj.electable_type + "-error-" + data.obj.electable_id).html(data.error_txt);
//     })
//     .on("ajax:success", function(evt, data, status, xhr){
//       $("." + data.obj.electable_type + "-" + data.obj.electable_id).html("Рейтинг: " + data.likes);
//       if(data.action == 1)
//       {
//         s = str_const("post");
//         s += (data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1) : get_href(data.q_id, data.a_id)
//         s += "?like=" + "-1" + "'>" + "dislike" + "</a><br>"

//         s += str_const("delete");
//         s += (data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1) : get_href(data.q_id, data.a_id)
//         s += "'>" + "cancel" + "</a><br>"
//       }
//       else if(data.action == -1)
//       {
//         s = str_const("post");
//         s += (data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1) : get_href(data.q_id, data.a_id)
//         s += "?like=" + "1" + "'>" + "like" + "</a><br>"

//         s += str_const("delete");
//         s += (data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1) : get_href(data.q_id, data.a_id)
//         s += "'>" + "cancel" + "</a><br>"
//       }
//       else if(data.action == 0)
//       {
//         s = str_const("post");
//         s += (data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1) : get_href(data.q_id, data.a_id)
//         s += "?like=" + "1" + "'>" + "like" + "</a><br>"

//         s += str_const("post");
//         s += (data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1) : get_href(data.q_id, data.a_id)
//         s += "?like=" + "-1" + "'>" + "dislike" + "</a><br>"
//       }
//       $(".links-" + data.obj.electable_type + "-" + data.obj.electable_id).html(s);
//     });
// });



$(document).ready(function () {

  function get_href(q_id, a_id, el_id) {
    if(a_id > 0)
    {
      return "/questions/" + q_id + "/answers/" + a_id + "/elects";
    }
    if(el_id > 0)
    {
      return "/elects/" + el_id;
    }
    return "/questions/" + q_id + "/elects";

  };

  $('a.like')
  .on("ajax:error", function(evt, xhr, status, error){

    $("." + data.obj.electable_type + "-error-" + data.obj.electable_id).html(data.error_txt);
  })
  .on("ajax:success", function(evt, data, status, xhr){
    $("." + data.obj.electable_type + "-" + data.obj.electable_id).html("Рейтинг: " + data.likes);
      first = $(".links-" + data.obj.electable_type + "-" + data.obj.electable_id + " .like")[0];
      second = $(".links-" + data.obj.electable_type + "-" + data.obj.electable_id + " .like")[1];
      if(data.action == 1)
      {
        $(first).text("dislike");
        $(first).attr("href", ((data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1, -1) : get_href(data.q_id, data.a_id))
           + "?like=-1");
        $(first).attr("data-method", "post");

        $(second).text("cancel");
        $(second).attr("href", ((data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1, data.obj.id) : get_href(data.q_id, data.a_id))
        + "?question_id="+ data.obj.electable_id);
        $(second).attr("data-method", "delete");
      }
      else if(data.action == -1)
      {
        $(first).text("like");
        $(first).attr("href", ((data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1, -1) : get_href(data.q_id, data.a_id))
           + "?like=1");
        $(first).attr("data-method", "post");

        $(second).text("cancel");
        $(second).attr("href", ((data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1, data.obj.id) : get_href(data.q_id, data.a_id))
        + "?question_id="+ data.obj.electable_id);
        $(second).attr("data-method", "delete");
      }
      else if(data.action == 0)
      {
        $(first).text("like");
        $(first).attr("href", ((data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1, -1) : get_href(data.q_id, data.a_id))
           + "?like=1");
        $(first).attr("data-method", "post");

        $(second).text("dislike");
        $(second).attr("href", ((data.obj.electable_type.toLowerCase() == "question") ? get_href(data.q_id, -1, -1) : get_href(data.q_id, data.a_id))
           + "?like=-1");
        $(second).attr("data-method", "post");
      }
  });
});





