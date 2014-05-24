class AddDescToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :desc, :string
  end
end
