class CouponRedemptionService
  def initialize(user:, coupon:, cart:)
    @user = user
    @coupon = coupon
    @cart = cart
  end

  def call
    user_coupon = UserCoupon.find_by(user: @user, coupon: @coupon)
    return { success: false, error: "Coupon not found for this user" } unless user_coupon
    return { success: false, error: "Coupon already used" } unless user_coupon.pending?

    discount_amount = discount_percentage ? (original_total * (discount_percentage / 100.0)) : 0
    final_total = original_total - discount_amount

    @cart.update(discount_percentage: discount_percentage, discount_amount: discount_amount, final_total: final_total, completed_at: DateTime.now)
    user_coupon.update(status: :redeemed, cart: @cart)

    { success: true }
  end

  private

  def discount_percentage
    @coupon.discount_percentage || 0
  end

  def original_total
    @cart.original_total || 0
  end
end
