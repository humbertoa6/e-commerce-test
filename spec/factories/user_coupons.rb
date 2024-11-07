FactoryBot.define do
  factory :user_coupon do
    user
    coupon
    status { "pending" }
    cart { nil }
  end
end
