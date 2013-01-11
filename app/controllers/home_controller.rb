class HomeController < ApplicationController
	skip_before_filter :require_login, :only => [:changelog]

	def index
		@user = @current_user
		@assignments = @user.assignments.where("due_date")
		@date = params[:month] ? Date.parse(params[:month]) : Date.today
	end

	def privacy
	end
	
	def changelog
		@versions = {
				"1.0.6"		=> ["Added ability to drop the lowest grade. Accessible from the assignment type edit page.",
								"Fixed privacy policy agreement requirements.",
								"Added ability to manage points-based courses"],

				"1.0.5" 	=> ["<strong>Fixed login dropdown so that it does not dissappear on the mobile site</strong>",
								"<strong>Added search to courses page.</strong>",
								"<strong>Fixed datepicker bug.</strong>",
								"<em>Updated privacy policy.</em>",
								"Added professor to course attributes.",
								"Added school to course attributes"],

				"1.0.4" 	=> ["<strong>Added registration confirmation check.</strong>",
								"Remove the less exciting themes (Wasabi Suicide, Cheer Up Emo Kid, Atomic Bikini, Wordless)",
								"Made font changes to some themes.",
								"Created a few new themes (Dark Wood, Canvas, Citrus, Darkness)."],

				"1.0.3" 	=> ["<strong>Added rough prioritizer tool.</strong>",
								"Added dropdown for assignment types on course information page."],

				"1.0.2"		=> ["Removed Course Name from Calendar",
								"Added Course Name tooltip to Calendar",
								"Removed labels and added popovers to all Forms"],

				"1.0.1"		=> ["<strong>Added Grade Report with printable styles</strong>",
								"<strong>Added GPA Prediction</strong>",
								"<strong>Course Page Changes</strong>",
								"Improved mobile theme.",
								"Added two themes: Condensed Milk, Whiteness.",
								"Optimized 'Assignment Type' grade (no effect on output)."],

				"1.0.0"		=> ["Register user",
								"Manage courses",
								"Manage grades",
								"Class progress",
								"Statistical analysis",
								"Class targetting",
								"Calendar view",
								"Password reset",
								"Submit feedback",
								"User themes"]

				}

		render layout:"login"
	end
end
