class ChangeDateTimetoTimestamp < ActiveRecord::Migration
  def up
  	  change_table :feed_items do |t|  
    t.change :published, :timestamp
    end
  end

  def down
  end
end
