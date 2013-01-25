class GradeScalesController < ApplicationController
	def index
		@grade_scales = GradeScale.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @grade_scales }
		end
	end

	def show
		@grade_scale = GradeScale.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @grade_scale }
		end
	end

	def new
		@course 		= Course.find(params[:id])
		@grade_scale 	= GradeScale.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @grade_scale }
		end
	end

	def edit
		@course 		= Course.find(params[:id])
		@grade_scale 	= @course.grade_scale
	end

	def create
		@course 		= Course.find(params[:course_id])
		@grade_scale 	= GradeScale.new(params[:grade_scale])
		@grade_scale.course_id = params[:course_id]

		respond_to do |format|
			if @grade_scale.save

				format.html { redirect_to @course, notice: 'Grade scale was successfully created.' }
				format.json { render json: @grade_scale, status: :created, location: @grade_scale }
			else
				format.html { render action: "new" }
				format.json { render json: @grade_scale.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@course 		= Course.find(params[:course_id])
		@grade_scale 	= GradeScale.find(params[:id])

		respond_to do |format|
			if @grade_scale.update_attributes(params[:grade_scale])
				LogsController.updateGradeScale(@current_user, @course)

				format.html { redirect_to @course, notice: 'Grade scale was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @grade_scale.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@grade_scale = GradeScale.find(params[:id])
		@grade_scale.destroy

		respond_to do |format|
			format.html { redirect_to grade_scales_url }
			format.json { head :no_content }
		end
	end
end
