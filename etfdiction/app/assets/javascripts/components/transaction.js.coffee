@Transaction = React.createClass
  render: ->
    React.DOM.tr null,
      React.DOM.td null, dateFormat(@props.transaction.created_at)
      React.DOM.td null, @props.transaction.name
      React.DOM.td null, @props.transaction.price
      React.DOM.td null, @props.transaction.quantity