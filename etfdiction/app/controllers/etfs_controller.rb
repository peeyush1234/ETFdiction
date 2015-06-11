class EtfsController < ApplicationController
  def index
    @day_3_high_low_etfs = "Boy"#Etf.day_3_high_low_etfs
  end

  def show
    render json: Etf.new(params[:name]).realtime_from_yahoo[:current] if params[:request] == 'current_price'
  end
end