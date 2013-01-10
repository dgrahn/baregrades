class GradesController < ApplicationController
	before_filter :get_variables

	def get_variables
		@assignment = Assignment.find(params[:assignment_id])
		@assignment_type = @assignment.assignment_type
		@course = @assignment_type.course
	end

	def index
		@grades = Grade.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @grades }
		end
	end

	def show
		@grade = Grade.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @grade }
		end
	end

	def new
		@grade = Grade.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @grade }
		end
	end

	def edit
		@grade = Grade.find_by_assignment_id_and_user_id(@assignment.id, @current_user.id)
	end

	def create
		@grade = Grade.new(params[:grade])
		@grade.assignment_id = params[:assignment_id]
		@grade.user_id = @current_user.id
		
		# Add log
		log = Log.new
		log.grade = @grade
		log.comments = "#{@current_user.name} added grade to assignment '#{@grade.assignment.name}'"
		log.save

		respond_to do |format|
			# For fast grades (:commit == "Save") redirect to the course page
			if params[:commit] == "Save" && @grade.save
					format.html { redirect_to course_path(@assignment.course), notice: 'Grade was successfully created.' }
			elsif @grade.save
				format.html { redirect_to assignment_path(@assignment), notice: 'Grade was successfully created.' }
			else
				format.html { render action: "new" }
			end
		end
	end

	def update
		@grade = Grade.find(params[:id])

		respond_to do |format|
			# For fast grades (:commit == "Save") redirect to the course page
			if params[:commit] == "Save" && @grade.update_attributes(params[:grade])
				# Add log
				log = Log.new
				log.grade = @grade
				log.comments = "#{@current_user.name} edited grade to assignment '#{@grade.assignment.name}'"
				log.save

				format.html { redirect_to course_path(@assignment.course), notice: 'Grade was successfully updated.' }
			elsif @grade.update_attributes(params[:grade])
				format.html { redirect_to assignment_path(@assignment), notice: 'Grade was successfully updated.' }
			else
				format.html { render action: "edit" }
			end
		end
	end

	def destroy
		grade = Grade.find_by_assignment_id_and_user_id(params[:assignment_id], @current_user.id)
		assignment = grade.assignment
		grade.destroy
		
		# Add log
		log = Log.new
		log.grade = @grade
		log.comments = "#{@current_user.name} deleted grade to assignment '#{assignment.name}'"
		log.save

		respond_to do |format|
			if params[:page] == "Course"
				format.html { redirect_to course_path(@assignment.course), notice: 'Grade was successfully destroyed.' }
			else
				format.html { redirect_to assignment_path(@assignment), notice: 'Grade was successfully destroyed.' }
				format.json { head :no_content }
			end
		end
	end
end