class UsersController < ApplicationController
	include UsersHelper
	skip_before_filter :require_login, :only => [:new, :create]

	def index
		# This option should only be usable by the administrators
		if not @current_user.is_administrator?
			redirect_to root_path
			return
		end

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
			format.html {render layout:"login"}
			format.json { render json: @user }
		end
	end

	def edit
		@user = User.find(params[:id])
		@themes = Theme.all
	end

	def create
		@user = User.new(params[:user])
		
		# Generate Confirmation Code
		@user.confirmation_code = generate_random_password
		@user.enabled = false
		
		respond_to do |format|
			if @user.save
				begin
					UserMailer.registration_confirmation(@user).deliver
					
					format.html { redirect_to login_path, notice: 'User was successfully created. Check your email to verify the account.'}
				rescue Net::SMTPFatalError # Mailer delivery error
					@user.destroy
					@themes = Theme.all
					
					format.html { 
						flash[:notice] = 'There was a problem with the email address.'
						render action: "new", layout:"login" 
					}
				end
			else
				@themes = Theme.all
				format.html { render action: "new", layout:"login" }
			end
		end
	end

	def update
		@user = User.find(params[:id])
		
		respond_to do |format|
			if (not @current_user.id == @user.id) && (not @current_user.is_administrator?)
				format.html {redirect_to root_path, notice: 'Access Denied.'}
				
			elsif @user.update_attributes(params[:user])
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
		if not @current_user.is_administrator?
			redirect_to root_path
		end
		
		@user = User.find(params[:id])
		@user.destroy

		respond_to do |format|
			format.html { redirect_to users_url }
			format.json { head :no_content }
		end
	end

	# GET /users/#/confirm/#
	def confirm
		user = User.find(params[:id])
		confirm = params[:confirm]
		
		respond_to do |format|
			if user.confirmation_code == confirm
				user.enabled = true
			else
				@themes = Theme.all
				format.html { redirect_to login_path, layout:"login", notice: 'Incorrect confirmation code.' }
			end
		
			if user.save
				format.html { redirect_to login_path, notice: 'User was successfully created. Check your email to verify the account.'}
			else
				@themes = Theme.all
				format.html { redirect_to login_path, layout:"login", notice: 'Unable to save the user.' }
			end
		end
	end
	
	# GET /users/#/confirm/#
	def admin_confirm
		user = User.find(params[:id])
		
		if (not @current_user.blank?) && @current_user.is_administrator?
			user.enabled = true
		end
		
		respond_to do |format|
			if user.save
				format.html { 
					flash[:notice] = 'The user has been enabled.'
					render json: @users 
				}
			else
				@themes = Theme.all
				format.html { 
					flash[:notice] = 'There was a problem enabling the user.'
					render json: @users 
				}
			end
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
