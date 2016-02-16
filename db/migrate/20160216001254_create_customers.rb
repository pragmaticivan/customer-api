class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.date :dob, null: false
      t.string :email, null: false
      t.string :phone, null: false

      t.timestamps null: false
    end
  end
end
