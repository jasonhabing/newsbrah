class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :sourceurl
      t.string :localcopy
      t.integer :big_story_id
      t.string :feed_item_id

      t.timestamps
    end
  end
end
