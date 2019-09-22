class AddUserIDsColumnToRatings < ActiveRecord::Migration[5.2]
  def change
    add_column :ratings, :votes, :string
  end
end
