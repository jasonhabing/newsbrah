class AddDescriptionToBigStory < ActiveRecord::Migration
  def change
    add_column :big_stories, :description, :text
  end
end
