class AddImageurlToBigStory < ActiveRecord::Migration
  def change
    add_column :big_stories, :imageurl, :text
  end
end
