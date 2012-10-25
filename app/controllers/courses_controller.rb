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
		respond_to do |format|
			format.html
			format.json { render json: @course }
		end
	end

	def info
	end

	def users
	end	

	def new
		@course = Course.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @course }
		end
	end

	def edit
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
		@course.destroy

		respond_to do |format|
			format.html { redirect_to courses_url }
			format.json { head :no_content }
		end
	end
end
