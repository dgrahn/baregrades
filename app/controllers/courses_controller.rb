class CoursesController < ApplicationController
	before_filter :find_course, :except => [:index, :new, :create]
	
	def find_course
		@course = Course.find(params[:id])
	end

	def index
		@courses = Course.all
		respond_to do |format|
			format.html
			format.json { render json: @courses }
		end
	end

	def show
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
	end	

	def new
		@course = Course.new
		@common_types = ["homework", "projects", "quizzes", "exams", "papers"]

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @course }
		end
	end

	def edit
	end

	def create
		types = ["homework", "projects", "quizzes", "exams", "papers"]

		# Create and save course
		@course = Course.new(params[:course])
		if not @course.save
			respond_to do |format|
				format.html { render action: "new" }
				format.json { render json: @course.errors, status: :unprocessable_entity }
			end
		end	

		# Create grade scale
		gs = GradeScale.new(course_id: @course.id)
		gs.save!
		

		types.each do |type|
			# Grab the hash from the params
			hash = params[type]

			if hash[:active] == 'true'
				# Create the assignment type
				at = AssignmentType.create(
						 name: type.titleize,
						worth: hash[:total].to_f,
					course_id: @course.id
					)

				at.save!

				# Create the assignments
				numberOfAssignments = hash[:number].to_f
				(1..numberOfAssignments).each do |i|
					a = Assignment.new()
					a.name = "#{type.titleize} #{i}"
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
		
		respond_to do |format|
			format.html { redirect_to @course, notice: 'Course was successfully created.' }
			format.json { render json: @course, status: :created, location: @course }
		end
	end

	def update
		respond_to do |format|
			if @course.update_attributes(params[:course])
				format.html { redirect_to @course, notice: 'Course was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @course.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		if not @current_user.is_administrator?
			redirect_to root_path
		end
		
		@course.destroy

		respond_to do |format|
			format.html { redirect_to courses_url }
			format.json { head :no_content }
		end
	end
end
