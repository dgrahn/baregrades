module ApplicationHelper
	def cp(path)
		if current_page?(path)
			"active"
		end
	end
end
