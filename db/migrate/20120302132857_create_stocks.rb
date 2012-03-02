class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.references :user,                                  :null => false
      t.string     :symbol,                                :null => false
      t.decimal    :shares, :precision => 12, :scale => 6, :null => false
      t.decimal    :price,  :precision => 12, :scale => 6, :null => false

      t.timestamps
    end

    add_index :stocks, :user_id
    add_index :stocks, :symbol
  end
end
