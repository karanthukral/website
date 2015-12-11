class ChangeImageToPolymorphic < ActiveRecord::Migration
  def up
    rename_column :images, :post_id, :owner_id
    add_column :images, :owner_type, :string
  end

  def down
    rename_column :images, :owner_id, :post_id
    remove_column :images, :owner_type
  end
end
