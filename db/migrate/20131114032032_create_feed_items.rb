class CreateFeedItems < ActiveRecord::Migration
  

  def change
    create_table :feed_items do |t|
      t.string :title
      t.string :url
      t.time :published
      t.string :author
      t.string :summary
      t.string :content
      t.string :categories
     

      t.timestamps
    end
  end
end
