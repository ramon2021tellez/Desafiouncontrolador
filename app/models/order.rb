class Order < ApplicationRecord
  ORDER_PREFIX = 'PO'
  RANDOM_SIZE = 9
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items 
  before_create -> { generate_number (RANDOM_SIZE) }

  validates :number, uniqueness: true

  def add_product(product_id, quantity)
    product = Product.find(product_id)
      if product && product.stock > 0
        order_items.create(product_id: product.id, quantity: quantity, price: product.price)
        the_total
      end
  end

  def generate_number(size)
    self.number = loop do
      rand_str = random_candidate(size)
      break rand_str unless Order.exists?(number: rand_str)
    end
  end

  def random_candidate(size)
    "#{ORDER_PREFIX}#{Array.new(size){rand(size)}.split}"
  end

  def the_total
    sum = 0
    order_items.each do |item|
      sum += item.price
    end
    update_attribute(:total,sum)
  end

    def in_cents
      self.total *100
    end
end