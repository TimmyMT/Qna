class AddColumnBestanswerToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :best_answer, references: :answers, index: true
  end
end
