module ApplicationHelper
	# If the path matches the current page, return the css
	# class "active"
	# @return [String] css class
	def cp(path)
		current_page?(path) ? "active" : ""
	end
	
	# Extend the link_to method so that an "active" class is
	# automatically applied if this is the current page
	# @param body [String]
	# @param url [String]
	# @param html_options [Hash]
	# @return [String] link
	def link_to(body, url, html_options = {})	
		if html_options[:class]
			html_options[:class] += " " + cp(url)
		else
			html_options[:class] = " " + cp(url)
		end

		super(body, url, html_options);
	end
	
	# Create a menu block used along the sidebar. Only
	# displays the menu if there is content passed in.
	# @param args [Array] title [String], content [String], and html_options [Hash]
	# @return [String] The side menu.
	def side_menu(*args, &block)
		if block_given?
			title 		 = args[0]
			content 	 = capture(&block)
			html_options = args[1] || {}

			side_menu(title, content, html_options)
		else
			title 		 = args[0]
			content 	 = args[1]
			html_options = args[2] || {}

			if content != nil and not content.empty?
				content_tag(:ul, html_options) do
					concat content_tag(:li, title)
					concat content
				end
			end
		end
	end
	
	# Used for creating a <li> with an <a> inside of it. This is
	# specifically helpful when creating a bootstrap menu.
	# @param args [Array] body [String], content [String], and html_options [Hash]
	# @return [String] The <li> with an <a>.
	def li_to(*args, &block)
		if block_given?
			url 		 = args[0] || {}
			html_options = args[1]

			li_to(capture(&block), url, html_options)
		else
			body 		 = args[0]
			url	 	 	 = args[1]
			html_options = args[2] || {}
			
			content_tag(:li, class:cp(url)) do
				link_to(body, url, html_options)
			end
		end
	end

	
	# Create the following: <span class="grade-class">grade</span>
	# @param grade [String]
	# @param course [String]
	# @return [String] The grade span.
	def grade_span(grade, course)
		content_tag(:span, class:course.grade_letter_class(grade)) do
			grade ? "%02d" % grade : ""
		end
	end

	# Add a bootstrap popover to a form element
	# @param title [String]
	# @param content [String]
	# @param example [ArrayList<String>]
	# @param placement [String]
	# @return [Hash] popover
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

	# Get the options for a grade path, either add or edit
	# @param assignment [assignment]
	# @return [Array] title, path
	def manage_grade_path(assignment)
		if assignment.user_grade(@current_user).blank?
			["Add Grade", new_assignment_grade_path(assignment)]
		else
			["Edit Grade", edit_assignment_grade_path(assignment)]
		end
	end

	# Get the fonts for a specified theme (if there are any)
	# @param theme [String]
	# @return [String] fonts
	def css_font(theme)
		case theme
			when "snowpurple"
				return "http://fonts.googleapis.com/css?family=Lato:300,400,700,900"
			when "citrus"
				return "http://fonts.googleapis.com/css?family=Permanent+Marker"
			when "darkness"
				return "http://fonts.googleapis.com/css?family=Old+Standard+TT"
		end
	end
end
