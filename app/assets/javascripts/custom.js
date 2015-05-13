$(document).ready(function(){
    $('.datepicker').datepicker({format: 'yyyy-mm-dd'});
    $('.conversation-scroll').scrollTop($('.conversation-scroll')[0].scrollHeight);
});
$(document).on('page:load', function(){
    $('.datepicker').datepicker({format: 'yyyy-mm-dd'});
});

//window.setInterval(function() { }, 5000);
