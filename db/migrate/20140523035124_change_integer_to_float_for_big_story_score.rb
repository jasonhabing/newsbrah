class ChangeIntegerToFloatForBigStoryScore < ActiveRecord::Migration
  def change
   change_column :big_stories, :score, :float
  end
end
