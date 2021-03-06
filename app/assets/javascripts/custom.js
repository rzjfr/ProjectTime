$(document).ready(function(){
    $('.datepicker').datepicker({format: 'yyyy-mm-dd'});
    $('.selectpicker').selectpicker('render');
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

    $(".nav-trigger").click(function() {
        $("body").toggleClass("show-sidebar");
        $(".nav-trigger").toggleClass("glyphicon-remove");
    });
    //$('.selectpicker').selectpicker('mobile');
});

$(document).on('page:load', function(){
    $('.datepicker').datepicker({format: 'yyyy-mm-dd'});
    $('.selectpicker').selectpicker('render');
    $('[data-toggle="tooltip"]').tooltip();
    //$('[data-toggle="popover"]').popover()
    $(".mobile-header-btn").click(function() {
        var text = $(this).attr('name');
        $("#" + text ).attr("class", "col-md-4 col-sm-4 col-xs-12 project-board");
        $(".mobile-header-btn").each(function() {
            if($(this).attr('name') !== text) {
            $("#" + $(this).attr('name')).attr("class","col-md-4 col-sm-4 project-board hidden-xs");
            }
        });
    });

    $(".nav-trigger").click(function() {
        $("body").toggleClass("show-sidebar");
        $(".nav-trigger").toggleClass("glyphicon-remove");
    });
    //$('.selectpicker').selectpicker('mobile');
});
