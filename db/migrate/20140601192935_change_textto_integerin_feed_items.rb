class ChangeTexttoIntegerinFeedItems < ActiveRecord::Migration
  def change
   change_column :feed_items, :source, :integer
  end
end
