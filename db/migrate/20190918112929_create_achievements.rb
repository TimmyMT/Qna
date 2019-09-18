class CreateAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :achievements do |t|
      t.string :name
      t.belongs_to :question, foreign_key: true
      t.belongs_to :user, foreign_key: true, default: nil

      t.timestamps
    end
  end
end
