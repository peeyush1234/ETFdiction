@Welcome = React.createClass
  getInitialState: ->
    transactions: []
    openPositions: []
    etfs: []
    etf_strategies: []

  getEtfList: ->
    $.get '/etfs',{request: 'etf_bull'}, (data) =>
      @setState etfs: data
    , 'JSON'

  getEtfStrategies: ->
    $.get '/etfs',{request: 'etf_strategies'}, (data) =>
      @setState etf_strategies: data
    , 'JSON'

  getOpenPositionsFromServer: ->
    $.get '/positions', (data) =>
      @setState openPositions: data
    , 'JSON'

  getAllTransactionsFromServer: ->
    $.get '/transactions', (data) =>
      @setState transactions: data
    , 'JSON'

  componentDidMount: ->
    @getAllTransactionsFromServer()
    @getOpenPositionsFromServer()
    @getEtfList()
    @getEtfStrategies()


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
      className: 'welcome'

      # -- Analysis --
      if marketOpen()
        React.createElement CurrentStatus, etfs: @state.etfs, etf_strategies: @state.etf_strategies
      else
        React.createElement TomorrowAnalysis, etfs: @state.etfs, etf_strategies: @state.etf_strategies

      # -- Open Positions --
      React.DOM.div
        className: 'panel panel-info'
        React.DOM.div
          className: 'panel-heading'
          React.DOM.h3
            className: 'panel-title'
            'Open Positions'
        React.DOM.div
          className: 'panel-body'
          React.DOM.table
            className: 'table table-condensed table-striped'
            React.DOM.thead null,
              React.DOM.tr null,
                React.DOM.th null, 'N'
                React.DOM.th null, 'AP'
                React.DOM.th null, 'Q'
                React.DOM.th null, 'CP'
            React.DOM.tbody null,
              for position in @state.openPositions
                React.createElement Position, key: position.name, position: position, pollInterval: 60000

      # -- Transactions --
      React.DOM.div
        className: 'panel panel-default'
        React.DOM.div
          className: 'panel-heading'
          React.DOM.h3
            className: 'panel-title'
            "Transactions"
        React.DOM.div
          className: 'panel-body'
          React.createElement TransactionForm, handleNewTransaction: @addTransaction
          React.DOM.table
            className: 'past-transactions table table-condensed table-striped'
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