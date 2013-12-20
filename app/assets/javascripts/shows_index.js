$(document).ready(function() {

  var debug = true;

  var pusher = new Pusher('26f4232b489d7c8a2e22', { authEndpoint: '/boards/auth' });
  
  var testing_channel = pusher.subscribe('test_channel');
  var board_presence_channel = pusher.subscribe('presence-of-boards');

  board_presence_channel.bind('pusher:subscription_succeeded', function(members) {
    members.each(function(member){
      if (member.info) {
        $('ul[data-board-id="' + member.info.mac + '"]').find("span.status").text("✔︎ Online");
        $('ul[data-board-id="' + member.info.mac + '"]').find("span.status").css("color","green");
      }
    });
  });

  board_presence_channel.bind('pusher:member_added', function(member) {
    $('ul[data-board-id="' + member.info.mac + '"]').find("span.status").text("✔︎ Online");
    $('ul[data-board-id="' + member.info.mac + '"]').find("span.status").css("color","green");
    
    var connected_board_ids = [];
    $('p.board_p').each(function(index, p) {
      connected_board_ids.push($(p).data('board-id'));
    })
    if($.inArray(member.info.mac, connected_board_ids) == -1) {
      $('.board_id_input').val(member.info.mac);
    }
  });

  board_presence_channel.bind('pusher:member_removed', function(member) {
    $('ul[data-board-id="' + member.info.mac + '"]').find("span.status").text("✘ Offline");
    $('ul[data-board-id="' + member.info.mac + '"]').find("span.status").css("color","red");
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

  $('#launcher').on('submit', function() {
    var board_id = $('input[name=board_radios]:checked').data('board-id')

    $('#board_id').val(board_id)
  });

  $("input:radio[name=board_radios]:first").attr('checked', true);
  $("input:radio[name=show_radios]:first").attr('checked', true);

  // $(document).change(function(){
  //   var status = $('.status').val()
  // });

});