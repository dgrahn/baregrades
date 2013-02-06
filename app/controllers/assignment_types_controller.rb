class AssignmentTypesController < ApplicationController
	include AssignmentTypesHelper
	include AssignmentsHelper
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
		@assignment_type.assign_attributes(params[:assignment_type])
		
		respond_to do |format|
			if @assignment_type.valid?
				LogsController.updateAssignmentType(@current_user, @assignment_type)
				@assignment_type.save

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
		
		respond_to do |format|
			# disable the assignments in the assignment type for the user
			assignment_type.assignments.each do |assignment|
				if not disableAssignment(assignment, @current_user)
					format.html { redirect_to course_info_path(@course), :flash => {:notice => "There was a problem disabling the assignment type"}}
				end
			end
		
			# Disable the assignment type for the user
			if disableAssignmentType(assignment_type, @current_user)
				format.html { redirect_to course_info_path(@course), :flash => {:success => "The assignment type was successfully disabled"}}
			else
				format.html { redirect_to course_info_path(@course), :flash => {:notice => "There was a problem disabling the assignment type"}}
			end # if flag.save
		end # do
	end # disable
	
	def enable
		assignment_type = AssignmentType.find(params[:id]);
		
		respond_to do |format|
			# enable the assignments in the assignment type for the user
			assignment_type.assignments.each do |assignment|
				if not enableAssignment(assignment, @current_user)
					format.html { redirect_to course_info_path(@course), :flash => {:notice => "There was a problem enabling the assignment type"}}
				end
			end
			
			# enable the assignment type for the user
			if enableAssignmentType(assignment_type, @current_user)
				format.html { redirect_to course_info_path(@course), :flash => {:success => "The assignment type was successfully enabled"}}
			else
				format.html { redirect_to course_info_path(@course), :flash => {:notice => "There was a problem enabling the assignment type"}}
			end # if
		end # do
	end # enable
end # assignment_types_controller