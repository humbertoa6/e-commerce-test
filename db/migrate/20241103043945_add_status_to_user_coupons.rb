class AddStatusToUserCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :user_coupons, :status, :string
  end
end
