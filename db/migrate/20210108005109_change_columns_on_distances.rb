class ChangeColumnsOnDistances < ActiveRecord::Migration[5.2]
  def up
    change_table :distances do |t|
      t.change :st_lat, :decimal, precision: 8, scale:6
      t.change :st_lng, :decimal, precision: 9, scale:6
      t.change :ed_lat, :decimal, precision: 8, scale:6
      t.change :ed_lng, :decimal, precision: 9, scale:6
    end
  end

  def down
    change_table :distances do |t|
      t.change :st_lat, :float
      t.change :st_lng, :float
      t.change :ed_lat, :float
      t.change :ed_lng, :float
    end
  end

end
