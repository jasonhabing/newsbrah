class CreateBigStories < ActiveRecord::Migration
  def change
    create_table :big_stories do |t|
      t.string :title
      t.string :image

      t.timestamps
    end
  end
end
