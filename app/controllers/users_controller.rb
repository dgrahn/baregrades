class UsersController < ApplicationController
	skip_before_filter :require_login, :only => [:new, :create]

	def index
		@users = User.all

		respond_to do |format|
			format.html
			format.json { render json: @users }
		end
	end

	def show
		@user = @current_user

		if @user.is_administrator? and params.has_key?(:id)
			@user = User.find(params[:id])
		end

		respond_to do |format|
			format.html
			format.json { render json: @user }
		end
	end

	def new
		@user = User.new
		@user.theme = Theme.find_by_name("Pond")
		@themes = Theme.all

		respond_to do |format|
			format.html {render :layout => "login"}
			format.json { render json: @user }
		end
	end

	def edit
		@user = User.find(params[:id])
		@themes = Theme.all
	end

	def create
		@user = User.new(params[:user])

		respond_to do |format|
			if @user.save
				format.html { redirect_to @user, notice: 'User was successfully created.' }
				format.json { render json: @user, status: :created, location: @user }
			else
				@themes = Theme.all
				format.html { render action: "new" }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@user = User.find(params[:id])

		respond_to do |format|
			if @user.update_attributes(params[:user])
				format.html { redirect_to @user, notice: 'User was successfully updated.' }
				format.json { head :no_content }
			else
				@themes = Theme.all
				format.html { render action: "edit" }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy

		respond_to do |format|
			format.html { redirect_to users_url }
			format.json { head :no_content }
		end
	end

	# POST /users/add_role/1
	def add_role
		@user = User.find(params[:id])
		@roles = Role.all

		respond_to do |format|
			format.html
		end
	end
end
