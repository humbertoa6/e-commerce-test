class CouponsController < ApplicationController
  before_action :set_coupon, only: [:edit, :update, :destroy]

  def redeem
    coupon = Coupon.find_by(code: params[:coupon_code])
    cart = Cart.find_by(id: params[:cart_id])
    result = CouponRedemptionService.new(user: current_user, coupon: coupon, cart: cart).call

    if result[:success]
      render "coupons/redeem_success", locals: { message: "Coupon applied successfully", cart: cart }
    else
      render "coupons/redeem_error", locals: { error: result[:error], cart: cart }
    end
  end

  def index
    @user_coupons = UserCoupon.includes(:user, :coupon).all
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)

    if @coupon.save
      user_ids = params[:coupon][:user_ids] || []
      @user_coupons = user_ids.map do |user_id|
        UserCoupon.create(user_id: user_id, coupon: @coupon, status: :pending)
      end

      flash[:notice] = 'Coupon created successfully'
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to coupons_path }
      end
    else
      flash[:alert] = 'Error. Please review mandatory fields.'
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("coupon_form", partial: "coupons/form", locals: { coupon: @coupon }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if params[:user_coupon_id].present?
      @user_coupon = UserCoupon.find(params[:user_coupon_id])
      @coupon = @user_coupon.coupon
    else
      @coupon = Coupon.find(params[:id])
    end

    existing_coupon = Coupon.find_by(code: coupon_params[:code], discount_percentage: coupon_params[:discount_percentage].to_f)

    if existing_coupon && existing_coupon != @coupon
      @user_coupon.update(coupon: existing_coupon) if @user_coupon
    elsif !existing_coupon
      @coupon = Coupon.create(coupon_params)
      @user_coupon.update(coupon: @coupon) if @user_coupon
    else
      @coupon.update(coupon_params)
    end

    respond_to do |format|
      flash[:notice] = 'Coupon updated successfully.'
      format.turbo_stream
      format.html { redirect_to coupons_path, notice: flash[:notice] }
    end
  end

  def destroy
    @coupon.destroy!

    respond_to do |format|
      flash[:notice] = 'Coupon deleted successfully.'
      format.turbo_stream {
        render turbo_stream: turbo_stream.remove("coupon_#{@coupon.id}")
      }

      format.html { redirect_to coupons_url, notice: 'Coupon deleted successfully.' }
      format.json { head :no_content }
    end
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end

  def coupon_params
    params.require(:coupon).permit(:code, :discount_percentage)
  end
end
