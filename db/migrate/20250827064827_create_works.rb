class CreateWorks < ActiveRecord::Migration[8.0]
  def change
    create_table :works do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject, null: false
      t.date :class_date, null: false
      t.integer :status, default: 0, null: false
      t.string :classroom, null: false
      t.integer :period, null: false
      t.integer :start_semester, null: false
      t.integer :end_semester, null: false

      t.timestamps
    end
  end
end
