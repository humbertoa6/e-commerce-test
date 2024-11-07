# spec/models/user_coupon_spec.rb
require 'rails_helper'

RSpec.describe UserCoupon, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:coupon) }
    it { is_expected.to belong_to(:cart).optional }
  end

  describe 'enums' do
    it 'defines the status enum as a string-backed enum with correct values' do
      expect(UserCoupon.statuses).to eq('pending' => 'pending', 'redeemed' => 'redeemed', 'expired' => 'expired')
    end
  end

  describe 'validations' do
    it 'validates inclusion of status in statuses keys' do
      is_expected.to allow_value('pending').for(:status)
      is_expected.to allow_value('redeemed').for(:status)
      is_expected.to allow_value('expired').for(:status)
    end
  end
end
