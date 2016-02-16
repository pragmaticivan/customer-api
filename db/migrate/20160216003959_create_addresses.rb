class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line1, null: false
      t.string :line2, null: false, default: ''
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.references :customer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
