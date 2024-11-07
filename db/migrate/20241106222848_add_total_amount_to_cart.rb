class AddTotalAmountToCart < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :original_total, :decimal, precision: 16, scale: 2
    add_column :carts, :discount_amount, :decimal, precision: 16, scale: 2
    add_column :carts, :final_total, :decimal, precision: 16, scale: 2
  end
end
