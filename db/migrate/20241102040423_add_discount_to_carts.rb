class AddDiscountToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :discount_percentage, :integer
  end
end
