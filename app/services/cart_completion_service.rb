class CartCompletionService
  MAX_DISCOUNT_PERCENTAGE = 30
  BASE_DISCOUNT_INCREMENT = 5
  LARGE_CART_THRESHOLD = 400
  ADDITIONAL_DISCOUNT = 10
  EXPIRATION_DAYS = 10

  def initialize(cart:, user:)
    @cart = cart
    @user = user
  end

  # Main method to execute the service logic
  def call
    apply_cart_completion_logic
    generate_and_assign_coupon
  end

  private

  # Marks the cart as completed and updates the user coupon status
  def apply_cart_completion_logic
    @cart.update!(completed_at: DateTime.now)
    current_user_coupon.update!(cart: @cart, status: :redeemed) if current_user_coupon.present?
  end

  # Generates a coupon with the calculated discount and assigns it to the user
  def generate_and_assign_coupon
    discount_percentage = calculate_discount
    gift_card_code = generate_gift_card_code
    expiration_date = Time.current + EXPIRATION_DAYS.days

    coupon = Coupon.create(
      code: gift_card_code,
      discount_percentage: discount_percentage,
      expiration_date: expiration_date
    )

    UserCoupon.create!(user: @user, coupon: coupon, status: :pending)

    coupon
  end

  # Calculates the total discount based on the number of purchases this month
  # and whether the cart total exceeds the large cart threshold
  def calculate_discount
    base_discount = [BASE_DISCOUNT_INCREMENT * purchases_this_month, MAX_DISCOUNT_PERCENTAGE].min
    total_discount = @cart.original_total > LARGE_CART_THRESHOLD ? base_discount + ADDITIONAL_DISCOUNT : base_discount
    [total_discount, MAX_DISCOUNT_PERCENTAGE].min # Ensure the discount does not exceed the maximum
  end

  # Counts the number of purchases the user has made in the current month
  def purchases_this_month
    start_of_month = Time.current.beginning_of_month
    Cart.where(user: @user, completed_at: start_of_month..Time.current).count
  end

  # Generates a unique gift card code that does not already exist in the database
  def generate_gift_card_code
    loop do
      code = SecureRandom.hex(6).upcase # Generate a random code
      break code unless Coupon.exists?(code: code) # Ensure the code is unique
    end
  end

  # Finds the user's current coupon associated with the cart, memoized for efficiency
  def current_user_coupon
    @current_user_coupon ||= UserCoupon.find_by(cart: @cart)
  end
end
