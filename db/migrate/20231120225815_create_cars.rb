class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :model
      t.integer :year
      t.integer :top_speed
      t.text :description
      t.integer :cc
      t.decimal :engine
      t.integer :mileage
      t.integer :price
      t.boolean :reserved, default: false

      t.timestamps
    end
  end
end
