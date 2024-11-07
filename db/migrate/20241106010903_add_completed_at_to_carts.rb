class AddCompletedAtToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :completed_at, :datetime
  end
end
