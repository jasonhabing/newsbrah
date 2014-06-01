class AddSourceidToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :sourceid, :integer
  end
end
