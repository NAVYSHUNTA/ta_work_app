class AddContextToWorks < ActiveRecord::Migration[8.0]
  def change
    add_column :works, :content, :text
  end
end
