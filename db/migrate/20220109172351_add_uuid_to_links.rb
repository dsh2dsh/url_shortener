class AddUuidToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :uuid, :string, null: false
    add_index :links, :uuid
  end
end
