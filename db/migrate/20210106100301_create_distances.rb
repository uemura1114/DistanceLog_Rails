class CreateDistances < ActiveRecord::Migration[5.2]
  def change
    create_table :distances do |t|
      t.float :st_lat
      t.float :st_lng
      t.float :ed_lat
      t.float :ed_lng
      t.float :distance

      t.timestamps
    end
  end
end
