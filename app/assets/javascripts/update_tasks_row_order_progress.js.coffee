console.log("this is update row order")
jQuery ->
  if $('#sortable-progress').length > 0
    #table_width = $('#sortable').width()
    #cells = $('.table').find('tr')[0].cells.length
    #desired_width = table_width / cells + 'px'
    #$('.table td').css('width', desired_width)

    $('#sortable-progress').sortable(
      axis: 'y'
      items: '.task-item-progress'
      cursor: 'move'

      update: (e, ui) ->
        item_id = ui.item.data('item-id')
        #console.log(item_id)
        position = ui.item.index()
        console.log(position)
        console.log(ui.item)
        $.ajax(
          type: 'POST'
          url: '/tasks/update_row_order'
          dataType: 'json'
          data: { task: {task_id: item_id, row_order_position: position } }
        )
    )
