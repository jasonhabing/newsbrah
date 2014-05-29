class AddPublishedToBigStory < ActiveRecord::Migration
  def change
  	add_column :big_stories, :published, :integer
  end
end
