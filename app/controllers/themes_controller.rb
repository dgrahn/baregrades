class ThemesController < ApplicationController
	#Renders index page.
	def index
		@themes = Theme.all

		respond_to do |format|
			format.html
			format.json { render json: @themes }
		end
	end
	#Renders show page.
	def show
		@theme = Theme.find(params[:id])

		respond_to do |format|
			format.html
			format.json { render json: @theme }
		end
	end
	#Renders new page.
	def new
		@theme = Theme.new

		respond_to do |format|
			format.html
			format.json { render json: @theme }
		end
	end
	#Renders edit page.
	def edit
		@theme = Theme.find(params[:id])
	end
	#Creates theme.
	def create
		@theme = Theme.new(params[:theme])

		respond_to do |format|
			if @theme.save
				format.html { redirect_to @theme, notice: 'Theme was successfully created.' }
				format.json { render json: @theme, status: :created, location: @theme }
			else
				format.html { render action: "new" }
				format.json { render json: @theme.errors, status: :unprocessable_entity }
			end
		end
	end

	#Updates theme.
	def update
		@theme = Theme.find(params[:id])

		respond_to do |format|
			if @theme.update_attributes(params[:theme])
				format.html { redirect_to @theme, notice: 'Theme was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @theme.errors, status: :unprocessable_entity }
			end
		end
	end

	#Deletes theme.
	def destroy
		@theme = Theme.find(params[:id])
		@theme.destroy

		respond_to do |format|
			format.html { redirect_to themes_url }
			format.json { head :no_content }
		end
	end
end