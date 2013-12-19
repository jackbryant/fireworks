$(document).ready(function() {
  $('input').iCheck({
    radioClass: 'iradio_square-blue',
    increaseArea: '20%'
  });

  var debug = true;

  var pusher = new Pusher('26f4232b489d7c8a2e22', { authEndpoint: '/boards/auth' });
  
  var testing_channel = pusher.subscribe('test_channel');
  var board_presence_channel = pusher.subscribe('presence-of-boards');

  board_presence_channel.bind('pusher:subscription_succeeded', function(members) {
    members.each(function(member){
      if (member.info) {
        $('ul[data-board-id="' + member.info.mac + '"]').find("div.status").text("Online");
      }
    });
  });

  board_presence_channel.bind('pusher:member_added', function(member) {
    // $('.messages').append("<div class=\"message\">" + member.info.mac + "</div>");
    $('ul[data-board-id="' + member.info.mac + '"]').find("div.status").text("Online");
    
    var connected_board_ids = [];
    $('article').each(function(index, article) {
      connected_board_ids.push($(article).data('board-id'));
    })
    if($.inArray(member.info.mac, connected_board_ids) == -1) {
      $('.board_id_input').val(member.info.mac);
    }
  });

  board_presence_channel.bind('pusher:member_removed', function(member) {
    $('ul[data-board-id="' + member.info.mac + '"]').find("div.status").text("Offline");
  });

  
  Pusher.log = function(message) {
    if (window.console && window.console.log) window.console.log(message);
  };

  $('button.upload').on ("click", function() {
    selected_board_id = $('input[name=board_radios]:checked').data('board-id');
    selected_show_id = $('input[name=show_radios]:checked').data('show-id');

    var upload_data = { show_id:selected_show_id, board_id: selected_board_id }; 

    $.ajax({
      url: "/shows/upload",
      type: "post",
      data:  upload_data,
      dataType: 'json',
      success: function(response){
        if (debug) {console.log("Show uploaded")};             
      },
      error:function(){
        if (debug) {console.log("Failed show upload")};
      }
    });
  })

  $("input:radio[name=board_radios]:first").iCheck('check');
  $("input:radio[name=show_radios]:first").iCheck('check');

});