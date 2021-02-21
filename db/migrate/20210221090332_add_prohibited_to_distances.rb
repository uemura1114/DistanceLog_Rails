class AddProhibitedToDistances < ActiveRecord::Migration[5.2]
  def change
    add_column :distances, :prohibited, :boolean, default: false, null: false
  end
end
