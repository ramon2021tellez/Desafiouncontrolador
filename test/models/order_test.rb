require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "generates a random number on create" do
    user = User.create(email: "test@test.com", password: '12345678')
    order = Order.create(user_id: user.id)
    assert !order.number.nil?
  end

  test 'number must be unique' do
    user = User.create(email: "test@test.cl", password: "12345678")
    order = Order.create(user_id: user.id)
    dup_order = order.dup

    assert_not dup_order.valid?
  end

  test 'adds products as order_items' do
    user = User.create(email: "test@test.cl", password: "12345678")
    order = Order.create(user_id: user.id)

    product = Product.create(name: "test", price: 999, stock: 15, sku: "001")
    order.add_product(product.id, 1)

    assert_equal(order.order_items.count, 1)
  end

  test "products with zero stock can't be added to the cart" do
    user = User.create(email: "test@test.cl", password: "12345678")
    order = Order.create(user_id: user.id)

    product = Product.create(name: "test", price: 9, stock: 0, sku: "001")
    order.add_product(product.id, 1)

    assert_equal(order.order_items.count, 0)
  end
end