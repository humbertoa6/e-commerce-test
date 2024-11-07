class CartController < ApplicationController
  def show
    items = Array.new(rand(3..5)) do
      {
        product_name: Faker::Commerce.product_name,
        quantity: rand(1..3),
        price: Faker::Commerce.price(range: 10.0..100.0).round(2)
      }
    end

    @cart = Cart.create(
      user: current_user,
      original_total: items.sum { |item| item[:quantity] * item[:price] },
      items: items
    )
  end

  def complete
    @cart = Cart.find(params[:id])
    service = CartCompletionService.new(cart: @cart, user: current_user)
    coupon = service.call

    redirect_to purchase_confirmation_path(@cart, gift_card_id: coupon.id)
  end

  def confirmation
    @cart = Cart.find(params[:id])
    @gift_card = Coupon.find(params[:gift_card_id])
  end

  private

  def generate_random_items
    self.items = Array.new(rand(3..5)) do
      {
        product_name: Faker::Commerce.product_name,
        quantity: rand(1..3),
        price: Faker::Commerce.price(range: 10.0..100.0).round(2)
      }
    end
  end
end
