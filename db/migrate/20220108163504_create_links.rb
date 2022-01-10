class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.string :url
      t.string :slug
      t.datetime :expire_at

      t.timestamps
    end
    add_index :links, :slug
    add_index :links, :expire_at
  end
end
