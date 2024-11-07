require 'rails_helper'

RSpec.describe CouponRedemptionService do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let(:coupon) { create(:coupon, discount_percentage: 20) }
  let!(:user_coupon) { create(:user_coupon, user: user, coupon: coupon, status: :pending) }

  subject { described_class.new(user: user, coupon: coupon, cart: cart) }

  describe '#call' do
    context 'when the user coupon does not exist' do
      it 'returns an error message' do
        user_coupon.destroy # Remove the user coupon to simulate non-existence
        result = subject.call
        expect(result).to eq({ success: false, error: "Coupon not found for this user" })
      end
    end

    context 'when the coupon has already been used' do
      it 'returns an error message' do
        user_coupon.update(status: :redeemed) # Mark the coupon as redeemed
        result = subject.call
        expect(result).to eq({ success: false, error: "Coupon already used" })
      end
    end

    context 'when the coupon is valid and pending' do
      it 'applies the discount to the cart and marks the coupon as redeemed' do
        result = subject.call

        expect(result).to eq({ success: true })
        expect(cart.reload.discount_percentage).to eq(20)
        expect(user_coupon.reload.status).to eq('redeemed')
        expect(user_coupon.cart).to eq(cart)
      end
    end
  end
end
