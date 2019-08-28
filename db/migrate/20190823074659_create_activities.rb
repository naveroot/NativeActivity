class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.references :city, null: false, foreign_key: true
      t.string :title
      t.string :description
      t.string :photo
      t.integer :price

      t.timestamps
    end
  end
end
