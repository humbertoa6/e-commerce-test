require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:user_coupons) }
    it { is_expected.to have_many(:users).through(:user_coupons) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:discount_percentage) }
  end

  describe '#expired?' do
    context 'when expiration_date is in the past' do
      it 'returns true' do
        coupon = Coupon.new(expiration_date: 1.day.ago)
        expect(coupon.expired?).to be true
      end
    end

    context 'when expiration_date is in the future' do
      it 'returns false' do
        coupon = Coupon.new(expiration_date: 1.day.from_now)
        expect(coupon.expired?).to be false
      end
    end
  end
end
