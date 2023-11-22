class AddFeaturedToCars < ActiveRecord::Migration[7.0]
  def change
    add_column :cars, :featured, :boolean
  end
end
