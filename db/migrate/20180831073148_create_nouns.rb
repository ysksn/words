class CreateNouns < ActiveRecord::Migration[5.2]
  def change
    create_table :nouns do |t|
      t.string :word, null: false
      t.integer :count, null: false
      t.references :source, null: false, foreign_key: true

      t.timestamps
    end
    add_index :nouns, :count
    add_index :nouns, %i[word source_id], unique: true
    add_index :nouns, %i[source_id word], unique: true
  end
end
