require 'rails_helper'

RSpec.describe UserCouponsController, type: :controller do
  let(:user) { create(:user, email: ENV['DEMO_USER_EMAIL']) }
  let(:coupon) { create(:coupon, code: 'DISCOUNT10', discount_percentage: 10) }
  let(:user_coupon) { create(:user_coupon, user: user, coupon: coupon) }

  before do
    allow(User).to receive(:find_by).and_return(user)
  end

  describe 'GET #edit' do
    it 'assigns the requested user_coupon and coupon' do
      get :edit, params: { id: user_coupon.id }
      expect(assigns(:user_coupon)).to eq(user_coupon)
      expect(assigns(:coupon)).to eq(user_coupon.coupon)
    end

    it 'renders the edit template' do
      get :edit, params: { id: user_coupon.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'when updating with an existing coupon' do
      let!(:existing_coupon) { create(:coupon, code: 'UPDATEDCODE', discount_percentage: 20) }

      it 'updates the user_coupon with the existing coupon' do
        patch :update, params: {
          id: user_coupon.id,
          user_coupon: { coupon_code: 'UPDATEDCODE', coupon_discount: 20 }
        }
        expect(user_coupon.reload.coupon).to eq(existing_coupon)
      end
    end

    it 'redirects to the coupons path with a success message' do
      patch :update, params: {
        id: user_coupon.id,
        user_coupon: { coupon_code: 'NEWCODE', coupon_discount: 30 }
      }
      expect(response).to redirect_to(coupons_path)
      expect(flash[:notice]).to eq('New coupon created and updated to user.')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user_coupon' do
      user_coupon
      expect {
        delete :destroy, params: { id: user_coupon.id }
      }.to change(UserCoupon, :count).by(-1)
    end

    it 'redirects to the coupons list with a success message' do
      delete :destroy, params: { id: user_coupon.id }
      expect(response).to redirect_to(coupons_url)
      expect(flash[:notice]).to eq('Coupon deleted successfully')
    end
  end
end
