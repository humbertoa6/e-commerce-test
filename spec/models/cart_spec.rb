# spec/models/cart_spec.rb
require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
