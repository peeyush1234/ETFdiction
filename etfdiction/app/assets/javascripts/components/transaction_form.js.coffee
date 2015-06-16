@TransactionForm = React.createClass
  handleChange: (e) ->
    name = e.target.name
    @setState "#{name}": e.target.value

  handleCheckboxChange: (e) ->
    name = e.target.name
    @setState "#{name}": e.target.checked

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
    DHL: ''

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
        React.DOM.div
          className: 'input-group'
          React.DOM.div
            className: 'input-group-addon'
            '$'
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
      React.DOM.div
        className: "checkbox"
        React.DOM.input
          type: "checkbox"
          name: "DHL"
          value: @state.DHL
          onChange: @handleCheckboxChange
          "DHL"
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary btn-sm'
        disabled: !@valid()
        'Add transaction'

