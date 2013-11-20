class FixDateOnFeedItem < ActiveRecord::Migration
  def up
    remove_column :feed_items, :published
    add_column :feed_items, :published, :datetime
  end

  def down
  end
end
