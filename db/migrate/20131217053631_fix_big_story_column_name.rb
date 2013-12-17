class FixBigStoryColumnName < ActiveRecord::Migration
def change
    rename_column :feed_items, :bigstory_id, :big_story_id
  end
end
