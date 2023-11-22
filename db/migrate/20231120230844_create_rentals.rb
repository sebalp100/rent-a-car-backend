class CreateRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals do |t|
      t.references :car, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :rental_date, default: -> { 'CURRENT_DATE' }, null: false
      t.date :return_date

      t.timestamps
    end
  end
end
