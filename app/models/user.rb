class User < ApplicationRecord
  has_many :user_coupons
  has_many :coupons, through: :user_coupons
end
