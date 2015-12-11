class FixWidgetsAndPostDates < ActiveRecord::Migration
  def change
    add_column :front_page_widgets, :image_url, "VARCHAR(500)"

    Post.all.each do |p|
      p.updated_at = p.created_at
      p.save
    end
  end
end
