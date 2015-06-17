@EtfStrategiesResult = React.createClass
  getInitialState: ->
    strategiesResult: []
    technicals: []

  getStrategiesResult: ->
    $.get "/etfs/#{@props.etf_name}",{request: @props.strategy_request_type}, (data) =>
      @setState strategiesResult: data
    , 'JSON'

  getEtfTechnicals: ->
    $.get "/etfs/#{@props.etf_name}", {request: "technicals"}, (data) =>
      @setState technicals: data
    , 'JSON'

  componentDidMount: ->
    @getStrategiesResult()
    @getEtfTechnicals()

  getStrategyResultClass: (result) ->
    if result == 1
      "success"
    else
      "default"

  render: ->
    React.DOM.tr null,
      React.DOM.td key: @props.etf_name,
        React.DOM.a
          className: "modal-link btn btn-sm"
          "data-toggle": "modal",
          "data-target": ".b-modal-sm-#{@props.etf_name}"
          @props.etf_name
        React.DOM.div
          className: "modal fade b-modal-sm-#{@props.etf_name}"
          tabIndex: "-1"
          role: "dialog"
          "aria-labelledby": "mySmallModalLabel"
          React.DOM.div
            className: "modal-dialog modal-sm"
            React.DOM.div
              className: "modal-content"
              React.DOM.h4
                className: "modal-title"
                @props.etf_name
              React.DOM.div
                className: "model-body"
                for technical in @state.technicals
                  React.DOM.p
                    key: technical.name,
                    "#{technical.name} -> #{technical.value}"
      for strategyResult in @state.strategiesResult
        React.DOM.td
          key: strategyResult.strategy_name,
          className: @getStrategyResultClass(strategyResult.result)
          strategyResult.result