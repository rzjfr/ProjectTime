jQuery ->
  $(".conversation-scroll").on 'scroll', ->
    more_posts_url = $(".pagination a[rel=next]").attr('href')
    if more_posts_url && $(".conversation-scroll").scrollTop() < 2
      $('.load-more').html('<img src="/ajax-loader.gif" alt="Loading..." title="Loading..." />')
      $.getScript more_posts_url
    return
  return
