class CreateBullets < ActiveRecord::Migration
  def change
    create_table :bullets do |t|
      t.text :content
      t.integer :big_story_id
      t.integer :rank

      t.timestamps
    end
  end
end
