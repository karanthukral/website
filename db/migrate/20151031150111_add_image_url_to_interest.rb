class AddImageUrlToInterest < ActiveRecord::Migration
  def change
    add_column :interests, :image_url, "VARCHAR(500)"

    Interest.all.each do |i|
    end
  end
end
