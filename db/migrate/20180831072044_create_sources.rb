class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources do |t|
      t.string :scheme, null: false
      t.string :path, null: false
      t.text :query
      t.string :fragment
      t.text :full_path, null: false
      t.references :host, null: false, foreign_key: true
      t.datetime :crawled_at

      t.timestamps
    end

    add_index :sources, :crawled_at
    add_index :sources, %i[full_path host_id], unique: true
    add_index :sources, %i[host_id full_path], unique: true
    add_index :sources, %i[scheme path query fragment host_id], unique: true, name: 'index_sources_on_sc_pa_qu_fr_ho'
  end
end
