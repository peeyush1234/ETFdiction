@Transactions = React.createClass
  getInitialState: ->
    transactions: @props.data
    openPositions: []

  getOpenPositionsFromServer: ->
    $.get '/positions', (data) =>
      @setState openPositions: data
    , 'JSON'

  componentDidMount: ->
    @getOpenPositionsFromServer()

  deleteTransaction: (transaction) ->
    transactions = @state.transactions.slice()
    index = transactions.indexOf transaction
    transactions.splice index, 1
    @setState transactions: transactions
    @getOpenPositionsFromServer()

  addTransaction: (transaction) ->
    transactions = @state.transactions.slice()
    transactions.unshift transaction
    @setState transactions: transactions
    @getOpenPositionsFromServer()

  render: ->
    React.DOM.div
      className: 'transactions'
      React.DOM.h2
        className: 'title'
        'Records'
      React.createElement TransactionForm, handleNewTransaction: @addTransaction
      React.DOM.h3
        className: 'title'
        'Open Positions'
      React.DOM.table
        className: 'table table-nonfluid table-bordered table-condensed'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Name'
            React.DOM.th null, 'Average Price'
            React.DOM.th null, 'Quantity'
            React.DOM.th null, 'Current Price'
        React.DOM.tbody null,
          for position in @state.openPositions
            React.createElement Position, key: position.name, position: position, pollInterval: 60000
      React.DOM.h3
        className: 'title'
        'All Transactions'
      React.DOM.table
        className: 'table table-bordered table-nonfluid table-condensed'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Date'
            React.DOM.th null, 'Name'
            React.DOM.th null, 'Price'
            React.DOM.th null, 'Quantity'
            React.DOM.th null, 'Actions'
        React.DOM.tbody null,
          for transaction in @state.transactions
            React.createElement Transaction, key: transaction.id, transaction: transaction, handleDeleteTransaction: @deleteTransaction