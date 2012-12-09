class AddConfirmationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_code, :string
    add_column :users, :enabled, :boolean, :null => false, :default => false
  end
end
