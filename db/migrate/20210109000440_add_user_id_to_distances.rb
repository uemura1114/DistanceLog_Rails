class AddUserIdToDistances < ActiveRecord::Migration[5.2]
  def change
    add_reference :distances, :user, foreign_key: true
  end
end
