class RemoveColumnBestanswerFromQuestions < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :best_answer_id, :string
  end
end
