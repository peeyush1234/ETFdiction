@TomorrowAnalysis = React.createClass
  render: ->
    React.DOM.div
      className: 'panel panel-info'
      React.DOM.div
        className: 'panel-heading'
        React.DOM.h3
          className: 'panel-title'
          'Tomorrow Analysis'
      React.DOM.div
        className: 'panel-body'
        React.DOM.table
          className: 'table table-condensed table-striped'
          React.DOM.thead null,
            React.DOM.tr null,
              React.DOM.th null, 'N'
              for strategy in @props.etf_strategies
                React.DOM.th key: strategy, strategy
          React.DOM.tbody null,
            for etf in @props.etfs
              React.createElement EtfStrategiesResult, key: etf, etf_name: etf, pollInterval: 60000
