class CreateAssignmentFlags < ActiveRecord::Migration
  def change
    create_table :assignment_flags do |t|
      t.integer :user_id
      t.integer :assignment_id
      t.boolean :disabled

      t.timestamps
    end
  end
end
