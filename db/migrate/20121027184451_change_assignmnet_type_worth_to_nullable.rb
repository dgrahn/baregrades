class ChangeAssignmnetTypeWorthToNullable < ActiveRecord::Migration
  def up
	change_column :assignment_types, :worth, :decimal, :null=>true
  end

  def down
  	change_column :assignment_types, :worth, :decimal, :null=>false
  end
end
