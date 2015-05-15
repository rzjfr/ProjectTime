jQuery ->
  $(".conversation-scroll").on 'scroll', ->
    more_posts_url = $(".pagination a[rel=next]").attr('href')
    if more_posts_url && $(".conversation-scroll").scrollTop() == 0
      $('.load-more').html('<img src="/ajax-loader.gif" alt="Loading..." title="Loading..." />')
      setTimeout (->
        $.getScript more_posts_url
        return
      ), 1000
    return
  return
