class AddNoteToWorks < ActiveRecord::Migration[8.0]
  def change
    add_column :works, :note, :text
  end
end
