class CreateUrlFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :url_files do |t|
      t.string :url, null: false
      t.belongs_to :url_fileable, polymorphic: true

      t.timestamps
    end
  end
end
