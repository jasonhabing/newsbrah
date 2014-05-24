class ChangeStringToTextInDesc < ActiveRecord::Migration
  def change
   change_column :feed_items, :desc, :text
  end
end
