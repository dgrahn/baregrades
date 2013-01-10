class AccessesController < ApplicationController
	def index
		@user = User.find(params[:user_id])
		@roles = @user.roles
		@all_access = Access.all
	end

	def new
		@user = User.find(params[:user_id])
		@access = Access.new
		@all_roles = Role.all
		@all_courses = Course.all
	end

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
	
	def join	
		@course = Course.find(params[:id])

		access = Access.new
		access.role = Role.find_by_name("Student")
		access.course = @course
		access.user = @current_user
		access.save

		# Add Log
		log = Log.new
		log.course = @course
		log.comments = "#{@current_user.name} joined the course '#{@course.name}'"
		log.save

		redirect_to @course
	end

	def leave
		@course = Course.find(params[:id])
		@access = Access.where(:course_id => @course.id, :user_id => @current_user.id).first
		
		# Add Log
		log = Log.new
		log.course = @course
		log.comments = "#{@current_user.name} left the course '#{@course.name}'"
		log.save
		
		if @access and @access.destroy
			redirect_to root_path, :flash => {:success => "You have left %s" % @course.name}
		else
			redirect_to root_path, :flash => {:success => "You were never in %s" % @course.name}
		end
	end

	def destroy
		@user = User.find(params[:user_id])
		@access = Access.find(params[:id])
		@access.destroy

		redirect_to @user, notice: 'Role was successfully removed.'
	end
end