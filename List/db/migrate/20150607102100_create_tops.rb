class CreateTops < ActiveRecord::Migration
  def change
    create_table :tops do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
