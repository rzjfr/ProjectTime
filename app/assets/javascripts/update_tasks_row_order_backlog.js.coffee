jQuery ->
  if $('#sortable-backlog').length > 0
    $('#sortable-backlog').sortable(
      axis: 'y'
      items: '.task-item-backlog'
      cursor: 'move'

      update: (e, ui) ->
        item_id = ui.item.data('item-id')
        #console.log(item_id)
        position = ui.item.index()
        console.log(position)
        $.ajax(
          type: 'POST'
          url: '/tasks/update_row_order'
          dataType: 'json'
          data: { task: {task_id: item_id, row_order_position: position } }
        )
    )
