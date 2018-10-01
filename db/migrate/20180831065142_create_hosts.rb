class CreateHosts < ActiveRecord::Migration[5.2]
  def change
    create_table :hosts do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :hosts, %i[name], unique: true
  end
end
