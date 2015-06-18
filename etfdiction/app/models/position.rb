class Position < ActiveRecord::Base
  validates :name, presence: true
  validates :average_price, presence: true
  validates :quantity, presence: true
  validates :base_etf, presence: true

  self.primary_key = :name
end