class ChangeColumnBestanswer < ActiveRecord::Migration[5.2]
  def change
    change_column_default :questions, :best_answer_id, nil
  end
end
