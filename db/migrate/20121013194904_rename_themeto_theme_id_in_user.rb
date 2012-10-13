class RenameThemetoThemeIdInUser < ActiveRecord::Migration
	def change
		rename_column :users, :theme, :theme_id
	end
end