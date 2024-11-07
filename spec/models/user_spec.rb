require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:user_coupons) }
    it { is_expected.to have_many(:coupons).through(:user_coupons) }
  end
end
