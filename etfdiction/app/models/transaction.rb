class Transaction < ActiveRecord::Base
  validates :name, presence: true
  validates :quantity, presence: true
  validates :price, presence: true

  before_save :capitalize_name

  def capitalize_name
    self.name.upcase!
  end
end