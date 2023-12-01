class AddStatusToRentals < ActiveRecord::Migration[7.0]
  def change
    add_column :rentals, :status, :string, default: 'pending'
    add_index :rentals, :status
  end
end
