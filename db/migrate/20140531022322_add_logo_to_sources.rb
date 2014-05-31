class AddLogoToSources < ActiveRecord::Migration
  def change
    add_column :sources, :logo, :string
  end
end
