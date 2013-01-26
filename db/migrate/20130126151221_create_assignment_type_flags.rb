class CreateAssignmentTypeFlags < ActiveRecord::Migration
  def change
    create_table :assignment_type_flags do |t|
      t.integer :user_id
      t.integer :assignment_type_id
      t.boolean :disabled

      t.timestamps
    end
  end
end
