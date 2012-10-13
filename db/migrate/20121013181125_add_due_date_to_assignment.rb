class AddDueDateToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :due_date, :date
  end
end
