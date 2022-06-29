class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :order, foreign_key: true
      t.references :payment_method, foreign_key: true
      t.string :state
      t.decimal :total
      t.string :token

      t.timestamps
    end
  end
end
