class AddBigStoryIdToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :bigstory_id, :integer
  end
end
