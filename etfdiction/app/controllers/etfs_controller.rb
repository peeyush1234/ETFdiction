class EtfsController < ApplicationController
  def index
    response = case params[:request]
      when 'etf_bull'
        Etf::ETF_BULL[:values].map do |etf_name|
          {
            name: etf_name,
            price_above_sma_200: Etf.new(etf_name).price_above_sma?(200) ? 1 : 0
          }
        end
      when 'a200_etf_strategies'
        Etf::A200_ETF_STRATEGIES.map{|i| i[:strategy_name]}
      when 'b200_etf_strategies'
        Etf::B200_ETF_STRATEGIES.map{|i| i[:strategy_name]}
      else
        raise 'Invalid request for Etfs index action'
    end

    render json: response
  end

  def show
    response = case params[:request]
      when 'current_price'
        Etf.new(params[:name]).realtime_from_yahoo[:current]
      when 'a200_strategies_result'
        Etf.new(params[:name]).a200_strategies_result
      when 'b200_strategies_result'
        Etf.new(params[:name]).b200_strategies_result
      else
        raise 'Invalid request for Etfs show action'
    end

    render json: response
  end
end