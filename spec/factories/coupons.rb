FactoryBot.define do
  factory :coupon do
    code { "DISCOUNT10" }
    discount_percentage { 10 }
    expiration_date { Time.current + 10.days }
  end
end
