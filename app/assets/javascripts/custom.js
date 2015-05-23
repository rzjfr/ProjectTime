$(document).ready(function(){
    $('.datepicker').datepicker({format: 'yyyy-mm-dd'});
    $('.conversation-scroll').scrollTop($('.conversation-scroll')[0].scrollHeight);
});
$(document).on('page:load', function(){
    $('.datepicker').datepicker({format: 'yyyy-mm-dd'});
});

//var a=$("#backlog .board-scroll");
//var b=$("tbody[digest=yt6845]");
//var a = $("tbody[digest=yt6845]").parent().parent()
//a.scrollTop(b.offset().top - a.offset().top + a.scrollTop());
//a.animate( { scrollTop: b.offset().top - a.offset().top + a.scrollTop()});


//window.setInterval(function() { }, 5000);
