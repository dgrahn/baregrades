class ChangeClassToCssClassInTheme < ActiveRecord::Migration
	def change
		rename_column :themes, :class, :css_class
	end
end
