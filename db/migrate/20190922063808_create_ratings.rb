class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :value, default: 0
      t.belongs_to :ratingable, polymorphic: true

      t.timestamps
    end
  end
end
