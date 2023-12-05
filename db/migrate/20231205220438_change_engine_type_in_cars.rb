class ChangeEngineTypeInCars < ActiveRecord::Migration[7.0]
  def change
    change_column :cars, :engine, :string
  end
end
