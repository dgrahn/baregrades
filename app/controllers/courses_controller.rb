class CoursesController < ApplicationController
	def index
		@courses = Course.all

		respond_to do |format|
			format.html
			format.json { render json: @courses }
		end
	end

	def show
		@course = Course.find(params[:id])

		respond_to do |format|
			format.html
			format.json { render json: @course }
		end
	end

	def users
		@course = Course.find(params[:id])
	end

	def new
		@course = Course.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @course }
		end
	end

	def edit
		@course = Course.find(params[:id])
	end

	def create
		@course = Course.new(params[:course])

		respond_to do |format|
			if @course.save
				format.html { redirect_to @course, notice: 'Course was successfully created.' }
				format.json { render json: @course, status: :created, location: @course }
			else
				format.html { render action: "new" }
				format.json { render json: @course.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@course = Course.find(params[:id])

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
		@course = Course.find(params[:id])
		@course.destroy

		respond_to do |format|
			format.html { redirect_to courses_url }
			format.json { head :no_content }
		end
	end
end
