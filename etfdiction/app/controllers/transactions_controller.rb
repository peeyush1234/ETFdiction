class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all.order(created_at: :desc)
  end

  def create
    transaction = Transaction.new(transaction_params)

    transaction.save!

    render json: transaction
  end

  def destroy
    Transaction.find(params[:id]).destroy
    head :no_content
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :quantity, :price)
  end
end