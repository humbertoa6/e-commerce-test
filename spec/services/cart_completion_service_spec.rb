# spec/services/cart_completion_service_spec.rb
require 'rails_helper'

RSpec.describe CartCompletionService, type: :service do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user, original_total: 500.0) }
  let(:service) { CartCompletionService.new(cart: cart, user: user) }

  describe '#call' do
    it 'marks the cart as completed' do
      service.call
      expect(cart.reload.completed_at).not_to be_nil
    end

    it 'updates the user coupon status to redeemed if a user coupon is present' do
      user_coupon = create(:user_coupon, user: user, cart: cart, status: 'pending')
      service.call
      expect(user_coupon.reload.status).to eq('redeemed')
    end

    it 'does not raise an error if no user coupon is present' do
      expect { service.call }.not_to raise_error
    end

    it 'generates a unique coupon for the user' do
      expect { service.call }.to change { Coupon.count }.by(1)
    end

    it 'assigns the new coupon to the user with pending status' do
      service.call
      user_coupon = UserCoupon.last
      expect(user_coupon.user).to eq(user)
      expect(user_coupon.status).to eq('pending')
    end

    it 'creates a coupon with the correct discount and expiration date' do
      service.call
      coupon = Coupon.last
      expect(coupon.discount_percentage).to be <= CartCompletionService::MAX_DISCOUNT_PERCENTAGE
      expect(coupon.expiration_date.to_date).to eq((Time.current + CartCompletionService::EXPIRATION_DAYS.days).to_date)
    end
  end

  describe '#calculate_discount' do
    it 'adds an additional discount for large carts' do
      # Base discount of 5% from 1 purchase + 10% additional = 15%
      create(:cart, user: user, completed_at: Time.current)
      allow(cart).to receive(:original_total).and_return(500) # Ensure the total exceeds LARGE_CART_THRESHOLD
      discount = service.send(:calculate_discount)
      expect(discount).to eq(15)
    end

    it 'does not exceed the maximum discount percentage' do
      create_list(:cart, 10, user: user, completed_at: Time.current)
      discount = service.send(:calculate_discount)
      expect(discount).to eq(CartCompletionService::MAX_DISCOUNT_PERCENTAGE)
    end
  end

  describe '#generate_gift_card_code' do
    it 'generates a unique gift card code' do
      allow(SecureRandom).to receive(:hex).and_return('UNIQUECODE')
      expect(service.send(:generate_gift_card_code)).to eq('UNIQUECODE')
    end

    it 'ensures the generated code is unique' do
      create(:coupon, code: 'UNIQUECODE')
      allow(SecureRandom).to receive(:hex).and_return('UNIQUECODE', 'NEWCODE')
      expect(service.send(:generate_gift_card_code)).to eq('NEWCODE')
    end
  end
end
