class CreateDistanceTagRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :distance_tag_relations do |t|
      t.references :distance, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
