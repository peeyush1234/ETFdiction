@Position= React.createClass
  getInitialState: ->
    current_price: ''

  getCurrentPriceFromServer: ->
    $.get "/etfs/#{@props.position.name}", {request: 'current_price'}, (data) =>
      @setState current_price: data
    , 'JSON'

  componentDidMount: ->
    @getCurrentPriceFromServer()
    setInterval @getCurrentPriceFromServer, @props.pollInterval

  getPriceClass: ->
    if parseFloat(@props.position.average_price) < parseFloat(@state.current_price)
      'success'
    else
      'error'

  render: ->
    React.DOM.tr null,
      React.DOM.td null, @props.position.name
      React.DOM.td null, @props.position.average_price
      React.DOM.td null, @props.position.quantity
      React.DOM.td
        className: @getPriceClass(),
        @state.current_price