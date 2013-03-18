class AccessesController < ApplicationController
	before_filter :check_admin_only, :except => [:join, :leave, :destroy]
	
	# Checks permissions.
	# Redirects to root path with an access denied message if not admin
	def check_admin_only
		
		if (not @current_user.is_administrator?)
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	# Creates new AcessesController.
	def new
		@user = User.find(params[:user_id])
		@access = Access.new
		@all_roles = Role.all
		@all_courses = Course.all
	end

	# Creates new AcessesController.
	def create
		@user = User.find(params[:user_id])
		@access = Access.new(params[:access])

		respond_to do |format|
		  if @access.save
			format.html { redirect_to @user, notice: 'Access was successfully created.' }
		  else
			format.html { render action: "new" }
		  end
		end
	end

	def update
	end
	
	# Joins current user to course.
	def join	
		@course = Course.find(params[:id])

		access = Access.new
		access.role = Role.find_by_name("Student")
		access.course = @course
		access.user = @current_user
		access.save

		LogsController.joinCourse(@current_user, @course)

		redirect_to @course
	end

	# Removes current user from course.
	def leave
		@course = Course.find(params[:id])
		@access = Access.where(:course_id => @course.id, :user_id => @current_user.id).first

		LogsController.leaveCourse(@current_user, @course)
		
		if @access and @access.destroy
			redirect_to root_path, :flash => {:success => "You have left %s" % @course.name}
		else
			redirect_to root_path, :flash => {:success => "You were never in %s" % @course.name}
		end
	end

	#Destroys access.
	def destroy
		@user = User.find(params[:user_id])
		@access = Access.find(params[:id])
		
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user == @user)
			redirect_to root_path, notice: "Access Denied"
			return
		end
		
		@access.destroy
		redirect_to @user, notice: 'Role was successfully removed.'
	end
end