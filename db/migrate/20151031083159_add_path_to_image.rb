class AddPathToImage < ActiveRecord::Migration
  def change
    add_column :images, :path, "VARCHAR(500)"
    add_column :images, :old_url, "VARCHAR(500)"
  end
end
