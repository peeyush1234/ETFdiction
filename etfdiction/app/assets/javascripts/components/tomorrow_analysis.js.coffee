@TomorrowAnalysis = React.createClass
  getInitialState: ->
    a200_etf_strategies: []
    b200_etf_strategies: []

  getA200EtfStrategies: ->
    $.get '/etfs',{request: 'a200_etf_strategies'}, (data) =>
      @setState a200_etf_strategies: data
    , 'JSON'

  getB200EtfStrategies: ->
    $.get '/etfs',{request: 'b200_etf_strategies'}, (data) =>
      @setState b200_etf_strategies: data
    , 'JSON'

  componentDidMount: ->
    @getA200EtfStrategies()
    @getB200EtfStrategies()

  render: ->
    React.DOM.div
      className: 'tomorrow-analysis'
      React.DOM.div
        className: 'panel panel-info'
        React.DOM.div
          className: 'panel-heading'
          React.DOM.h3
            className: 'panel-title'
            "Above 200 SMA"
        React.DOM.div
          className: 'panel-body'
          React.DOM.table
            className: 'table table-condensed table-striped'
            React.DOM.thead null,
              React.DOM.tr null,
                React.DOM.th null, 'N'
                for strategy in @state.a200_etf_strategies
                  React.DOM.th key: strategy, strategy
            React.DOM.tbody null,
              for etf in @props.etfs
                if etf.price_above_sma_200 == 1
                  React.createElement EtfStrategiesResult,
                    key: etf.name,
                    etf_name: etf.name,
                    strategy_request_type: 'a200_strategies_result'
      React.DOM.div
        className: 'panel panel-info'
        React.DOM.div
          className: 'panel-heading'
          React.DOM.h3
            className: 'panel-title'
            "Below 200 SMA"
        React.DOM.div
          className: 'panel-body'
          React.DOM.table
            className: 'table table-condensed table-striped'
            React.DOM.thead null,
              React.DOM.tr null,
                React.DOM.th null, 'N'
                for strategy in @state.b200_etf_strategies
                  React.DOM.th key: strategy, strategy
            React.DOM.tbody null,
              for etf in @props.etfs
                if etf.price_above_sma_200 == 0
                  React.createElement EtfStrategiesResult,
                    key: etf.name,
                    etf_name: etf.name,
                    strategy_request_type: 'b200_strategies_result'