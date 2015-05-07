jQuery ->
  if $('#sortable-done').length > 0
    $('#sortable-done').sortable(
      axis: 'y'
      items: '.task-item-done'
      cursor: 'move'

      sort: (e, ui) ->
        ui.item.addClass('active-item-shadow')
      stop: (e, ui) ->
        ui.item.removeClass('active-item-shadow')
        # highlight the row on drop to indicate an update
        ui.item.children('td').effect('highlight', {}, 1000)
      update: (e, ui) ->
        item_id = ui.item.data('item-id')
        #console.log(item_id)
        position = ui.item.index() * 4
        console.log(position)
        $.ajax(
          type: 'POST'
          url: '/tasks/update_row_order'
          dataType: 'json'
          data: { task: {task_id: item_id, row_order_position: position } }
        )
    )
