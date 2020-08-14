class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :name
      t.string :image_url
      t.string :content
      t.string :status

      t.timestamps
    end
  end
end
