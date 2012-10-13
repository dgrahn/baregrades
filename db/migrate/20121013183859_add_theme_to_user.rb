class AddThemeToUser < ActiveRecord::Migration
	def change
		add_column :users, :theme, :integer
	end
end