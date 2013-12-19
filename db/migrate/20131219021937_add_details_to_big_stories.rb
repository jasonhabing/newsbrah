class AddDetailsToBigStories < ActiveRecord::Migration
  def change
    add_column :big_stories, :breakingdate, :datetime
    add_column :big_stories, :latestdate, :datetime
  end
end
