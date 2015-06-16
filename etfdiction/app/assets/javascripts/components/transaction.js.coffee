@Transaction = React.createClass
  handleDelete: (e) ->
    if confirm('Sure?')
      e.preventDefault()
      $.ajax
        method: 'DELETE'
        url: "/transactions/#{ @props.transaction.id }"
        dataType: 'JSON'
        success: () =>
          @props.handleDeleteTransaction @props.transaction

  render: ->
    React.DOM.tr null,
      React.DOM.td null, dateFormat(@props.transaction.created_at)
      React.DOM.td null, @props.transaction.name
      React.DOM.td null, @props.transaction.price
      React.DOM.td null, @props.transaction.quantity
      React.DOM.td null, @props.transaction.strategy
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-danger btn-sm'
          onClick: @handleDelete
          'Delete'