class AssignmentTypesController < ApplicationController
	before_filter :find_course, :only => [:new, :edit, :create, :update, :destroy]
	before_filter :check_courses, :only => [:new, :edit, :create, :update, :destroy]

	def find_course
		@course = Course.find(params[:course_id])
	end
	
	def check_courses
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user.courses.include?(@course))
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	def new
		@assignment_type = AssignmentType.new
		
		respond_to do |format|
			format.html
		end
	end

	def edit
		@assignment_type = AssignmentType.find(params[:id])
	end

	def create
		assignment_page = params[:assignment_page]
		@assignment_type = AssignmentType.new(params[:assignment_type])
		@assignment_type.course = @course
		
		respond_to do |format|
			if @assignment_type.save
				# Add log
				log = Log.new
				log.assignment_type = @assignment_type
				log.course = @course
				log.comments = "#{@current_user.name} created assignment type '#{@assignment_type.name}'."
				log.save
				
				#Generate Assignments
				hash = params["gen"]
				numberOfAssignments = hash[:number].to_f
				(1..numberOfAssignments).each do |i|
						a = Assignment.new()
						a.name = "#{@assignment_type.name}  #{i}"
						a.worth = hash[:assignmentworth].to_f
						a.assignment_type = @assignment_type
						a.save!
				end
				
				#if(assignment_page)
				#	format.html { redirect_to new_assignment_path(@course), :flash => {:success => "Assignment type was successfully created."} }
				#else
					format.html { redirect_to course_info_path(@course), :flash => {:success => "Assignment type was successfully created."} }
				#end
			else
				format.html { render action: "new" }
			end
		end
	end

	def update
		@assignment_type = AssignmentType.find(params[:id])
		
		respond_to do |format|
			if @assignment_type.update_attributes(params[:assignment_type])
				# Add log
				log = Log.new
				log.assignment_type = @assignment_type
				log.course = @course
				log.comments = "#{@current_user.name} updated assignment type '#{@assignment_type.name}'."
				log.save

				format.html { redirect_to course_info_path(@course), :flash => {:success => "Assignment Type was successfully updated."}}
			else
				format.html { render action: "edit" }
			end
		end
	end

	def destroy
		@assignment_type = AssignmentType.find(params[:id])
		@assignment_type.assignments.each do |assignment|
			assignment.destroy
		end
		
		# Add log
		log = Log.new
		log.assignment_type = @assignment_type
		log.course = @course
		log.comments = "#{@current_user.name} deleted assignment type '#{@assignment_type.name}'."
		log.save

		@assignment_type.destroy

		respond_to do |format|
			format.html { redirect_to course_info_path(@course), :flash => {:success => "Assignment Type was successfully deleted"}}
		end
	end
end