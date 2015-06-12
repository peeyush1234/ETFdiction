class EtfsController < ApplicationController
  def index
    response = case params[:request]
      when 'etf_bull'
        Etf::ETF_BULL[:values]
      when 'etf_strategies'
        Etf::ETF_STRATEGIES.map{|i| i[:display_name]}
      else
        raise 'Invalid request for Etfs index action'
    end

    render json: response
  end

  def show
    response = case params[:request]
      when 'current_price'
        Etf.new(params[:name]).realtime_from_yahoo[:current]
      when 'strategies_result'
        Etf::ETF_STRATEGIES.map{|i| {strategy_name: i[:display_name], result: "BAM"}}
      else
        raise 'Invalid request for Etfs show action'
    end

    render json: response
  end
end