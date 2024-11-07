class CreateUserCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :user_coupons do |t|
      t.references :user, null: false, foreign_key: true
      t.references :coupon, null: false, foreign_key: true
      t.datetime :redeemed_at

      t.timestamps
    end
  end
end
