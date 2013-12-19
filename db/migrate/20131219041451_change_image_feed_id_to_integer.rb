class ChangeImageFeedIdToInteger < ActiveRecord::Migration
  def up
  	change_column :images, :feed_item_id, :integer
  end

  def down
  end
end
