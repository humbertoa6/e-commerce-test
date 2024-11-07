class AddCartIdToUserCoupons < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_coupons, :cart, foreign_key: true, null: true
  end
end
