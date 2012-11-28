module ApplicationHelper
	def cp(path)
		if current_page?(path)
			"active"
		else
			""
		end
	end
	
	def link_to(body, url, html_options = {})	
		if html_options[:class]
			html_options[:class] += " " + cp(url)
		else
			html_options[:class] = " " + cp(url)
		end

		super(body, url, html_options);
	end

	def popover(title, content, example = nil, placement = "right")
		if example
			if example.is_a? String
				content += "<span>Example: #{example}</span>"
			else
				example.each do |ex|
					content += "<span>Example: #{ex}</span>"
				end
			end
		end

		return {
			placeholder:title,
			rel:"popover",
			:data => {
				placement:placement,
				title:title,
				content:content
			}
		}
	end
	
	def manage_grade_path(assignment, clas)
		if assignment.user_grade(@current_user).blank?
			link_to "Add Grade", new_assignment_grade_path(assignment), :class => clas
		else
			link_to "Edit Grade", edit_assignment_grade_path(assignment), :class => clas 
		end
	end
end
