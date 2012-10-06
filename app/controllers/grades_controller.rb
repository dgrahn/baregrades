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
		@grade = Grade.find(params[:id])
	end

	def create
		@grade = Grade.new(params[:grade])
		@grade.assignment_id = params[:assignment_id]
		@grade.user_id = @current_user.id

		respond_to do |format|
			if @grade.save
				format.html { redirect_to @assignment, notice: 'Grade was successfully created.' }
			else
				format.html { render action: "new" }
			end
		end
	end

	def update
		@grade = Grade.find(params[:id])

		respond_to do |format|
			if @grade.update_attributes(params[:grade])
				format.html { redirect_to @assignment, notice: 'Grade was successfully updated.' }
			else
				format.html { render action: "edit" }
			end
		end
	end

	def destroy
		@grade = Grade.find(params[:id])
		@grade.destroy

		respond_to do |format|
			format.html { redirect_to grades_url }
			format.json { head :no_content }
		end
	end
end