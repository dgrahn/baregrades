BareGrades::Application.routes.draw do
  resources :themes

	root :to => "home#index"

	get "privacy" 						=> "home#privacy", 			as:"privacy"
	get "changelog"						=> "home#changelog",		as:"changelog"
	get "help"							=> "home#help",				as:"help"
	get "login" 						=> "sessions#new", 			as:"login"
	get "logout" 						=> "sessions#destroy",		as:"logout"
	get "admin"							=> "admin#index",			as:"admin"
	get "admin/logs/:number"			=> "admin#logs",			as:"logs"
	get "admin/possess/:id"				=> "users#possess",			as:"possess"
	get "grade_report"					=> "tools#grade_report",	as:"grade_report"
	get "gpa_prediction"				=> "tools#gpa_prediction",	as:"gpa_prediction"
	get "prioritizer"					=> "tools#prioritizer",		as:"prioritizer"
	get "courses/:id/join" 				=> "accesses#join", 		as:"course_join"
	get "courses/:id/leave" 			=> "accesses#leave", 		as:"course_leave"
	get "courses/:id/users" 			=> "courses#users", 		as:"course_users"
	get "courses/:id/info" 				=> "courses#info", 			as:"course_info"
	get "courses/:id/calendar" 			=> "courses#calendar", 		as:"course_calendar"
	get "courses/:id/assignment/new" 	=> "assignments#new", 		as:"new_assignment"
	get "courses/:id/edit_scale" 		=> "grade_scales#edit", 	as:"edit_grade_scale"
	get "courses/:id/new_scale" 		=> "grade_scales#new", 		as:"new_grade_scale"
	get "courses/:id/target"			=> "tools#target_grade", 	as:"target_grade"
	get "notifications"					=> "notifications#index", 	as:"notifications"
	get "notifications/:id/destroy"		=> "notifications#destroy",	as:"notification_destroy"	
	get "assignments/:id/disable"		=> "assignments#disable",	as:"disable_assignment"
	get "assignments/:id/enable"		=> "assignments#enable",	as:"enable_assignment"
	get "download_calendars"				=> "users#download_calendars", as:"user_download_calendars"
	get "courses/:id/download_calendar" 	=> "courses#download_calendar", 	as:"course_download_calendar"
	get "courses/:course_id/assignment_types/:id/enable" 	=> "assignment_types#enable", as:"course_assignment_type_enable"
	get "courses/:course_id/assignment_types/:id/disable" 	=> "assignment_types#disable", as:"course_assignment_type_disable"

	get "courses/:id/analysis" 				=> "analysis#index", 				as:"analysis"
	get "courses/:id/analysis/types"		=> "analysis#assignment_types", 	as:"assignment_types_analysis"
	get "courses/:id/analysis/assignments" 	=> "analysis#assignments",			as:"assignments_analysis"
	get "courses/:id/analysis/course"		=> "analysis#course",				as:"course_analysis"

	resources :sessions
	resources :roles
	resources :assignments

	resources :courses do
		resources :assignment_types
		resources :grade_scales
	end	

	post "fast_grade"					=> "grades#fast_grade",		as:"fast_grade"
	resources :assignments do
		resources :grades
	end
	


	get "account" 							=> "users#show", 			as:"account"
	get "account/:id" 						=> "users#show"
	get "register" 							=> "users#new", 			as:"register"
	get "users/:id/courses" 				=> "users#courses", 		as:"users_courses"
	get "users/:id/confirm/:confirm" 		=> "users#confirm", 		as:"confirm"
	get "users/:id/admin_confirm"			=> "users#admin_confirm", 	as:"admin_confirm"
	resources :users
	resources :users do
		resources :accesses
	end

	# Routes the user to the Form web page
	get "feedback" 			=> "user_mailer#feedback", as:"feedback"
	get "forgotPassword"	=> "user_mailer#forgotPassword", as:"forgotPassword"
	
	# Routes to the user_mailer controller
	post "submitFeedback" => "user_mailer#submitFeedback", as:"submitFeedback"
	post "resetPassword" => "user_mailer#resetPassword", as:"resetPassword"
	
	#match "/users/:id/access" => "access#index", as::user
	#match "/users/:id/access/new" => "access#new", as::user

	# The priority is based upon order of creation:
	# first created -> highest priority.

	# Sample of regular route:
	#   match 'products/:id' => 'catalog#view'
	# Keep in mind you can assign values other than :controller and :action

	# Sample of named route:
	#   match 'products/:id/purchase' => 'catalog#purchase', as::purchase
	# This route can be invoked with purchase_url(:id => product.id)

	# Sample resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products

	# Sample resource route with options:
	#   resources :products do
	#     member do
	#       get 'short'
	#       post 'toggle'
	#     end
	#
	#     collection do
	#       get 'sold'
	#     end
	#   end

	# Sample resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Sample resource route with more complex sub-resources
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', :on => :collection
	#     end
	#   end

	# Sample resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end

	# You can have the root of your site routed with "root"
	# just remember to delete public/index.html.
	# root :to => 'welcome#index'

	# See how all your routes lay out with "rake routes"

	# This is a legacy wild controller route that's not recommended for RESTful applications.
	# Note: This route will make all actions in every controller accessible via GET requests.
	# match ':controller(/:action(/:id))(.:format)'
end
