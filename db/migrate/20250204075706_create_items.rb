class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.integer :price
      t.text :description
      t.string :title

      t.timestamps
    end
  end
end
