class Coupon < ApplicationRecord
  has_many :user_coupons
  has_many :users, through: :user_coupons

  validates :code, presence: true
  validates :discount_percentage, presence: true

  def expired?
    expiration_date < Time.current
  end
end
