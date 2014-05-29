class AddImageAttrToBigStory < ActiveRecord::Migration
  def change
    add_column :big_stories, :imageattr, :text
  end
end
