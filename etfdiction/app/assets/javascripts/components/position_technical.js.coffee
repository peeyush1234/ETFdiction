@PositionTechnical = React.createClass
  getInitialState: ->
    technicals: ''

  getEtfTechnicals: ->
    $.get "/etfs/#{@props.position.base_etf}", {request: "position_technicals"}, (data) =>
      @setState technicals: data
    , 'JSON'

  componentDidMount: ->
    @getEtfTechnicals()
    setInterval @getEtfTechnicals, @props.pollInterval

  render: ->
    React.DOM.tr null,
      React.DOM.td null, @props.position.base_etf
      React.DOM.td null, @state.technicals.sma_5
      React.DOM.td null, @state.technicals.rsi_4
      React.DOM.td null, @state.technicals.rsi_2
      React.DOM.td null, @props.position.strategy