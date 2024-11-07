class UserCoupon < ApplicationRecord
  belongs_to :user
  belongs_to :coupon
  belongs_to :cart, optional: true

  enum status: { pending: 'pending', redeemed: 'redeemed', expired: 'expired' }

  validates :status, inclusion: { in: statuses.keys }
end
