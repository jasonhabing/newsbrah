class FixImageTableForHeroku < ActiveRecord::Migration
  def up

  	remove_column :images, :feed_item_id
  	add_column :images, :feed_item_id, :integer

  end

  def down
  end
end
