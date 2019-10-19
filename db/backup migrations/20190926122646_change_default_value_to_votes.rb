class ChangeDefaultValueToVotes < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:votes, :value, 0)
  end
end
