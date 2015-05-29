#http://js2.coffee/
#$('table[id^=sortable]').each(function(){ IDs.push(this.id); })
#var IDs = $('table[id^=sortable]').map(function() { return this.id; }).get()
#var IDs = IDs.filter(function(itm,i,a){ return i==a.indexOf(itm); });
#IDs.forEach(function(tag, i){});

jQuery ->
  IDs = $('table[id^=sortable]').map(-> @id).get()
  IDs = IDs.filter((itm, i, a) -> i == a.indexOf(itm))
  #console.log(IDs)
  IDs.forEach (tag, i) ->
    jQuery ->
      #console.log("#"+tag)
      if $("#"+tag).length > 0
        $("#"+tag).sortable(
          axis: 'y'
          items: '.task-item'
          cursor: 'move'

          update: (e, ui) ->
            item_id = ui.item.data('item-id')
            #console.log(item_id)
            position = ui.item.index()
            #console.log(position)
            $.ajax(
              type: 'POST'
              url: '/tasks/update_row_order'
              dataType: 'json'
              data: { task: {task_id: item_id, row_order_position: position } }
            )
        )
