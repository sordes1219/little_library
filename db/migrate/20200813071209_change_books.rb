class ChangeBooks < ActiveRecord::Migration[5.1]
  def change
    remove_column :books,:status,:string
  end
end
