class RenamePeriodAndAddEndPeriodToWorks < ActiveRecord::Migration[8.0]
  def change
    rename_column :works, :period, :start_period
    add_column :works, :end_period, :integer, null: false
  end
end
