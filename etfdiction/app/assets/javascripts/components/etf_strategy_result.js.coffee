@EtfStrategiesResult = React.createClass
  getInitialState: ->
    strategiesResult: []

  getStrategeisResult: ->
    $.get "/etfs/#{@props.etf_name}",{request: 'strategies_result'}, (data) =>
      console.log(data)
      @setState strategiesResult: data
    , 'JSON'

  componentDidMount: ->
    @getStrategeisResult()

  render: ->
    React.DOM.tr null,
      React.DOM.td key: @props.etf_name, @props.etf_name
      for strategyResult in @state.strategiesResult
        React.DOM.td key: strategyResult.strategy_name, strategyResult.result