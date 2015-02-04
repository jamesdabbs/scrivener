class CreateHooks < ActiveRecord::Migration
  def change
    create_table :hooks do |t|
      t.string :source
      t.text :payload

      t.timestamps null: false
    end
  end
end
