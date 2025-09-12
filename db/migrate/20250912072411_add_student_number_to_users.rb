class AddStudentNumberToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :student_number, :string, null: false
    add_index :users, :student_number, unique: true
  end
end
