class AddBestFeedToBigStory < ActiveRecord::Migration
  def change
    add_column :big_stories, :bestfeed, :integer
  end
end
