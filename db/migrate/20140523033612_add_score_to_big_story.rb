class AddScoreToBigStory < ActiveRecord::Migration
  def change
    add_column :big_stories, :score, :integer
  end
end
