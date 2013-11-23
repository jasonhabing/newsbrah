class CreateTitleWords < ActiveRecord::Migration
  def change
    create_table :title_words do |t|
      t.integer :feeditemid
      t.string :word1
      t.string :word2
      t.string :word3
      t.string :word4
      t.string :word5
      t.string :word6
      t.string :word7
      t.string :word8
      t.string :word9
      t.string :word10
      t.string :word11
      t.string :word12
      t.string :word13
      t.string :word14
      t.string :word15
      t.string :word16
      t.string :word17
      t.string :word18
      t.string :word19
      t.string :word20

      t.timestamps
    end
  end
end
