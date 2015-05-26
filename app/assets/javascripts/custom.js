$(document).ready(function(){
    $('.datepicker').datepicker({format: 'yyyy-mm-dd'});
    $('.conversation-scroll').scrollTop($('.conversation-scroll')[0].scrollHeight);
    $('[data-toggle="tooltip"]').tooltip();
    //$('[data-toggle="popover"]').popover()
    $(".mobile-header-btn").click(function() {
        var text = $(this).attr('name');
        $("#" + text ).attr("class", "col-md-4 col-sm-4 col-xs-12 project-board");
        //$("#" + text ).switchClass("hidden-xs col-xs-6", "col-xs-12", 1000, "easeInOutQuad" );
        //$("#" + text ).animate({class: "col-md-4 col-sm-4 col-xs-12 project-board"}, "slow");
        $(".mobile-header-btn").each(function() {
            if($(this).attr('name') !== text) {
            $("#" + $(this).attr('name')).attr("class","col-md-4 col-sm-4 project-board hidden-xs");
            }
        });
    });
});

$(document).on('page:load', function(){
    $('.datepicker').datepicker({format: 'yyyy-mm-dd'});
    $('[data-toggle="tooltip"]').tooltip();
    $('.conversation-scroll').scrollTop($('.conversation-scroll')[0].scrollHeight);
    //$('[data-toggle="popover"]').popover()
});

//var a=$("#backlog .board-scroll");
//var b=$("tbody[digest=yt6845]");
//var a = $("tbody[digest=yt6845]").parent().parent()
//a.scrollTop(b.offset().top - a.offset().top + a.scrollTop());
//a.animate( { scrollTop: b.offset().top - a.offset().top + a.scrollTop()});

//window.setInterval(function() { }, 5000);
