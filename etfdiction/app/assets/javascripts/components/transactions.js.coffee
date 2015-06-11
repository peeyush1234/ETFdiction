@Transactions = React.createClass
  getInitialState: ->
    transactions: @props.data

  getDefaultProps: ->
    transactions: []

  addTransaction: (transaction) ->
    transactions = @state.transactions.slice()
    transactions.push transaction
    @setState transactions: transactions

  render: ->
    React.DOM.div
      className: 'transactions'
      React.DOM.h2
        className: 'title'
        'Records'
      React.createElement TransactionForm, handleNewTransaction: @addTransaction
      React.DOM.hr null
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Date'
            React.DOM.th null, 'Name'
            React.DOM.th null, 'Price'
            React.DOM.th null, 'Quantity'
        React.DOM.tbody null,
          for transaction in @state.transactions
            React.createElement Transaction, key: transaction.id, transaction: transaction