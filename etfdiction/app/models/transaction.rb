class Transaction < ActiveRecord::Base
  validates :name, presence: true
  validates :quantity, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :base_etf, presence: true

  before_save :capitalize_name
  after_create :update_position
  before_destroy :fix_position

  def capitalize_name
    self.name.upcase!
  end

  def update_position
    positions = Position.where(name: self.name)
    if positions.present?
      position = positions.first
      existing_amount = position.quantity * position.average_price
      new_amount = self.quantity * self.price
      total_quantity = position.quantity + self.quantity
      total_amount = existing_amount + new_amount
      position.average_price = total_quantity == 0 ? 0 : (total_amount/total_quantity).round(2)
      position.strategy = total_quantity == 0 ? nil : position.strategy.to_s.split(",").concat(self.strategy.to_s.split(',')).uniq.join(',')
      position.quantity = total_quantity
      position.save!
    else
      Position.create!(name: self.name, quantity: self.quantity, average_price: self.price, base_etf: self.base_etf)
    end
  end

  def fix_position
    position = Position.where(name: self.name).first
    existing_amount = position.quantity * position.average_price
    error_amount = self.quantity * self.price
    fixed_amount = existing_amount - error_amount
    fixed_quantity = position.quantity - self.quantity
    position.quantity = fixed_quantity
    position.average_price = fixed_quantity == 0 ? 0 : (fixed_amount/fixed_quantity).round(2)
    position.strategy = nil if fixed_quantity == 0
    position.save!
  end
end