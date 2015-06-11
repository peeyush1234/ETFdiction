class PositionsController < ApplicationController
  def index
    positions = Position.where.not(quantity: 0).order(updated_at: :desc)
    render json: positions
  end
end