class AddExpirationDateToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :expiration_date, :datetime
  end
end
