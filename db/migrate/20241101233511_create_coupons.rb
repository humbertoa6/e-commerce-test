class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :discount_percentage
      t.datetime :expires_at
      t.integer :max_redemptions
      t.integer :redemptions_count
      t.boolean :is_redeemable

      t.timestamps
    end
  end
end
