class AssignmentTypesController < ApplicationController
	before_filter :find_course, :only => [:new, :edit, :create, :update, :destroy, :disable, :enable]
	before_filter :check_courses, :only => [:new, :edit, :create, :update, :destroy, :disable, :enable]

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
				LogsController.createAssignmentType(@current_user, @assignment_type)
				
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
				
				format.html { redirect_to course_info_path(@course), :flash => {:success => "Assignment type was successfully created."} }
			else
				format.html { render action: "new" }
			end
		end
	end

	def update
		@assignment_type = AssignmentType.find(params[:id])
		
		respond_to do |format|
			if @assignment_type.update_attributes(params[:assignment_type])
				LogsController.updateAssignmentType(@current_user, @assignment_type)

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
		
		LogsController.destroyAssignmentType(@current_user, @assignment_type)

		@assignment_type.destroy

		respond_to do |format|
			format.html { redirect_to course_info_path(@course), :flash => {:success => "Assignment Type was successfully deleted"}}
		end
	end
	
	def disable
		# find flag for assignment type and user
		assignment_type = AssignmentType.find(params[:id])
		flag = AssignmentTypeFlag.find_by_assignment_type_id_and_user_id(assignment_type.id, @current_user.id)
		
		respond_to do |format|
			# check flag
			if flag.blank?
				# create a flag to disable
				flag = AssignmentTypeFlag.new();
				flag.assignment_type = assignment_type;
				flag.user = @current_user;
				flag.disabled = true;
				
			else
				# change the flag to disable
				flag.disabled = true
			end
			
			# save the flag
			if flag.save
				format.html { redirect_to course_info_path(@course), :flash => {:success => "The assignment type was successfully disabled"}}
			else
				format.html { redirect_to course_info_path(@course), :flash => {:notice => "There was a problem disabling the assignment type"}}
			end # if flag.save
		end # do
	end # disable
	
	def enable
		assignment_type = AssignmentType.find(params[:id])
		flag = AssignmentTypeFlag.find_by_assignment_type_id_and_user_id(assignment_type.id, @current_user.id)
		
		respond_to do |format|
			if assignment_type.disabled and flag.blank? # the assignmenttype is disabled and no flag
				# create a flag disabled = false
				flag = AssignmentTypeFlag.create(:assignment_type_id => assignment_type.id, :user_id => @current_user.id, :disabled => false)
				
				# Save the flag with disabled as false
				if flag.save
					format.html { redirect_to course_info_path(@course), :flash => {:success => "The assignment type was successfully enabled"}}
				else
					format.html { redirect_to course_info_path(@course), :flash => {:notice => "There was a problem enabling the assignment type"}}
				end
			
			elsif assignment_type.disabled and not flag.blank? # the assignment type is disabled and there is a flag
				# make the flag enable the assignment type
				flag.disabled = false;
				
				# save the flag with disabled as false
				if flag.save
					format.html { redirect_to course_info_path(@course), :flash => {:success => "The assignment type was successfully enabled"}}
				else
					format.html { redirect_to course_info_path(@course), :flash => {:notice => "There was a problem enabling the assignment type"}}
				end
				
			elsif not assignment_type.disabled and not flag.blank? # the assignment is not disabled, but there is a flag that disables
				# delete the flag making the assignment disabled for the user
				if flag.destroy
					format.html { redirect_to course_info_path(@course), :flash => {:success => "The assignment type was successfully enabled"}}
				else
					format.html { redirect_to course_info_path(@course), :flash => {:notice => "There was a problem enabling the assignment type"}}
				end # if
			end # if
		end # do
	end # enable
end # assignment_types_controller