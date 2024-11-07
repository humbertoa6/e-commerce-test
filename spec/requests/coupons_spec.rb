# spec/controllers/coupons_controller_spec.rb
require 'rails_helper'

RSpec.describe CouponsController, type: :controller do
  let(:user) { create(:user, email: ENV['DEMO_USER_EMAIL']) }
  let(:coupon) { create(:coupon) }
  let(:cart) { create(:cart, user: user) }
  let(:valid_coupon_params) { { code: 'NEWCOUPON', discount_percentage: 15 } }
  let(:invalid_coupon_params) { { code: '', discount_percentage: nil } }

  before do
    allow(User).to receive(:find_by).with(email: ENV['DEMO_USER_EMAIL']).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @user_coupons' do
      user_coupon = create(:user_coupon, user: user, coupon: coupon)
      get :index
      expect(assigns(:user_coupons)).to include(user_coupon)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new coupon' do
      get :new
      expect(assigns(:coupon)).to be_a_new(Coupon)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new coupon' do
        expect {
          post :create, params: { coupon: valid_coupon_params }
        }.to change(Coupon, :count).by(1)
      end

      it 'creates associated user coupons' do
        user_ids = [user.id]
        expect {
          post :create, params: { coupon: valid_coupon_params.merge(user_ids: user_ids) }
        }.to change(UserCoupon, :count).by(1)
      end

      it 'redirects to coupons_path with a success notice' do
        post :create, params: { coupon: valid_coupon_params }
        expect(response).to redirect_to(coupons_path)
        expect(flash[:notice]).to eq('Coupon created successfully')
      end
    end

    context 'with invalid params' do
      it 'does not create a new coupon' do
        expect {
          post :create, params: { coupon: invalid_coupon_params }
        }.not_to change(Coupon, :count)
      end

      it 'renders the new template with unprocessable_entity status' do
        post :create, params: { coupon: invalid_coupon_params }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested coupon' do
      get :edit, params: { id: coupon.id }
      expect(assigns(:coupon)).to eq(coupon)
    end

    it 'renders the edit template' do
      get :edit, params: { id: coupon.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the coupon' do
      coupon_to_delete = create(:coupon)
      expect {
        delete :destroy, params: { id: coupon_to_delete.id }
      }.to change(Coupon, :count).by(-1)
    end

    it 'redirects to coupons_path with a success notice' do
      delete :destroy, params: { id: coupon.id }
      expect(response).to redirect_to(coupons_path)
      expect(flash[:notice]).to eq('Coupon deleted successfully.')
    end
  end
end
