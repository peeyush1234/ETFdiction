class TransactionsController < ApplicationController
  def index
    render json: Transaction.all.order(created_at: :desc)
  end

  def create
    t_params = params[:transaction]
    strategies_to_include = []
    Etf::STRATEGIES_LIST.each do |st|
      if t_params[st.to_s] == "true"
        strategies_to_include << st.to_s
      end
    end

    transaction = Transaction.new(name: t_params[:name], base_etf: t_params[:baseName], price: t_params[:price], quantity: t_params[:quantity], strategy: strategies_to_include.join(','))

    transaction.save!

    render json: transaction
  end

  def destroy
    Transaction.find(params[:id]).destroy
    head :no_content
  end

  private

end