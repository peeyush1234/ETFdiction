@TransactionForm = React.createClass
  handleChange: (e) ->
    name = e.target.name
    @setState "#{name}": e.target.value

  valid: ->
    @state.name && @state.price && @state.quantity

  handleSubmit: (e) ->
    e.preventDefault()
    $.post '/transactions', {transaction: @state}, (data) =>
      @props.handleNewTransaction data
      @setState @getInitialState
    , 'JSON'

  getInitialState: ->
    name: ''
    price: ''
    quantity: ''

  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control input-sm'
          placeholder: 'Name'
          name: 'name'
          value: @state.name
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control input-sm'
          placeholder: 'Price'
          name: 'price'
          value: @state.price
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control input-sm'
          placeholder: 'Quantity'
          name: 'quantity'
          value: @state.quantity
          onChange: @handleChange
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary btn-sm'
        disabled: !@valid()
        'Add transaction'
