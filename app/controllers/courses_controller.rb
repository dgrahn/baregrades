class CoursesController < ApplicationController
	before_filter :find_course, 		:except => [:index, :new, :create]
	before_filter :check_admin_only,	:only 	=> [:users, :destroy]
	before_filter :check_courses, 		:only 	=> [:edit, :update]
	
	@@common_types = ["homework", "projects", "quizzes", "exams", "papers", "labs", "participation", "midterms", "finals"]
	
	def find_course
		@course = Course.find(params[:id])
	end
	
	def check_admin_only
		# Check permissions
		if (not @current_user.is_administrator?)
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end

	def check_courses
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user.courses.include?(@course))
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	def index
		@courses = Course.all
		respond_to do |format|
			format.html
			format.json { render json: @courses }
		end
	end

	def show
		@disabled	= @course.disabled_assignments(@current_user)
		@upcoming 	= @course.upcoming_assignments(@current_user)
		@undated 	= @course.undated_assignments(@current_user)
		@past 		= @course.past_assignments(@current_user)
		@graded		= @course.graded_assignments(@current_user)
		
		# The number of uncompleted assignments
		@num_uncompleted = @upcoming.length + @undated.length
		
		if @num_uncompleted + @past.length + @graded.length != 0
			@percent_completed = 100 * (@past.length + @graded.length) /
									(@num_uncompleted + @past.length + @graded.length)
		end

		if @upcoming.last
			@days_left = (@upcoming.last.due_date - Date.today).to_i;
		end

		respond_to do |format|
			format.html
			format.json { render json: @course }
		end
	end
	
	def calendar
		@course = Course.find(params[:id])
		@date = params[:month] ? Date.parse(params[:month]) : Date.today
		@assignments = @course.assignments.where("due_date")
	end

	def info
	end

	def users
		# must have admin access
	end	

	def new
		@course = Course.new
		@common_types = @@common_types

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @course }
		end
	end

	def edit
		# must have admin access or be in the course
	end

	def create
		@common_types = @@common_types
		
		# Create the course
		@course = Course.new(params[:course])
		
		# Move the professor into the professors table.
		professor_name = params[:professor]
		prof = Professor.find_by_name(professor_name)
		
		if not prof
			prof = Professor.create(name:professor_name)
		end
		
		@course.professor = prof
		
		# Move the school into the schools table.
		school_name = params[:school]
		sch = School.find_by_name(school_name)
		
		if not sch
			sch = School.create(name:school_name)
		end

		@course.school = sch


		respond_to do |format|
			# Save the course
			if not @course.save
				format.html { render action: "new" }
				format.json { render json: @course.errors, status: :unprocessable_entity }
			end	

			# Create grade scale
			gs = GradeScale.new(course_id: @course.id)
			gs.save!
			

			10.times do |type|
				# Grab the hash from the params
				hash = params[type.to_s]
				name = hash[:name].titleize

				if name != ""
					# Create the assignment type
					at = AssignmentType.create(
							 name: name.pluralize,
							worth: hash[:total].to_f,
						course_id: @course.id
						)

					at.save!

					# Create the assignments
					numberOfAssignments = hash[:number].to_f
					(1..numberOfAssignments).each do |i|
						a = Assignment.new()
						a.name = "#{name.singularize} #{i}"
						a.worth = hash[:worth].to_f
						a.assignment_type = at
						a.save!
					end #assignments
				end #if active
			end #assignment types
			
			# Have the user join the course
			access = Access.new()
			access.role = Role.find_by_name("Student")
			access.course = @course
			access.user = @current_user
			access.save

			LogsController.addCourse(@current_user, @course)

			format.html { redirect_to @course, notice: 'Course was successfully created.' }
			format.json { render json: @course, status: :created, location: @course }
		end
	end

	def update
		# must have admin access or be in the course
		
		# Move professor to seperate table
		professor_name = params[:professor]
		prof = Professor.find_by_name(professor_name)
		
		if not prof
			prof = Professor.create(name:professor_name)
		end
		
		@course.professor = prof
		
		# Move school to seperate table
		school_name = params[:school]
		sch = School.find_by_name(school_name)
		
		if not sch
			sch = School.create(name:school_name)
		end
		
		@course.school = sch
		
		@course.assign_attributes(params[:course])

		respond_to do |format|
			if @course.valid?
				LogsController.updateCourse(@current_user, @course)
				@course.save

				format.html { redirect_to @course, notice: 'Course was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @course.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		# must have admin access
		
		# Add log
		LogsController.destroyCourse(@current_user, @course)
		
		@course.destroy

		respond_to do |format|
			format.html { redirect_to courses_url }
			format.json { head :no_content }
		end
	end
end
