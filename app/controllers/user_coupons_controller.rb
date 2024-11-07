class UserCouponsController < ApplicationController
  before_action :set_user_coupon, only: [:edit, :update, :destroy]

  def edit
    @coupon = @user_coupon.coupon
  end

  def update
    new_code = params[:user_coupon][:coupon_code]
    new_discount = params[:user_coupon][:coupon_discount].to_f
    existing_coupon = Coupon.find_by(code: new_code, discount_percentage: new_discount)

    if existing_coupon && existing_coupon != @user_coupon.coupon
      @user_coupon.update(coupon: existing_coupon)
    elsif !existing_coupon
      new_coupon = Coupon.create(code: new_code, discount_percentage: new_discount)
      @user_coupon.update(coupon: new_coupon)
    end

    respond_to do |format|
      flash[:notice] = 'New coupon created and updated to user.'
      format.turbo_stream
      format.html { redirect_to coupons_path, notice: flash[:notice] }
    end
  end

  def destroy
    @user_coupon.destroy

    respond_to do |format|
      flash[:notice] = 'Coupon deleted successfully.'
      format.turbo_stream
      format.html { redirect_to coupons_url, notice: 'Coupon deleted successfully' }
      format.json { head :no_content }
    end
  end

  private

  def set_user_coupon
    @user_coupon = UserCoupon.find(params[:id])
  end
end
