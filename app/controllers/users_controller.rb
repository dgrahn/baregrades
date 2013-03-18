class UsersController < ApplicationController
	include UsersHelper
	skip_before_filter :require_login, 	:only => [:new, :create, :confirm]
	before_filter :find_user, 			:only => [:courses, :edit, :update, :destroy, :confirm, :admin_confirm, :add_role]
	before_filter :check_admin_only, 	:only => [:index, :courses, :destroy, :admin_confirm, :possess]
	before_filter :check_user, 			:only => [:edit, :update, :add_role]

	#Finds user.
	def find_user
		@user = User.find(params[:id])
	end
	
	#Checks that user is admin.
	def check_admin_only
		# Check permissions
		if (not @current_user.is_administrator?)
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	#Checks user permissions.
	def check_user
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user == @user)
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	#Renders user page.
	def index
		@users = User.all

		respond_to do |format|
			format.html
			format.json { render json: @users }
		end
	end

	#Renders show page.
	def show
		@user = @current_user

		# Check permissions
		if @user.is_administrator? and params.has_key?(:id)
			@user = User.find(params[:id])
		end

		respond_to do |format|
			format.html
			format.json { render json: @user }
		end
	end

	# Shows all of the courses that a single user is in
	def courses
	end	
	#Renders page for creating a new user.
	def new
		@user = User.new
		@user.theme = Theme.find_by_name("Pond")
		@themes = Theme.all

		respond_to do |format|
			format.html {render layout:"login"}
			format.json { render json: @user }
		end
	end

	#Renders edit page.
	def edit
		@themes = Theme.all
	end

	#Saves user.
	def create
		@user = User.new(params[:user])
		policy = params[:policy]
		
		# Generate Confirmation Code
		@user.confirmation_code = generate_random_password
		@user.enabled = false
			
		respond_to do |format|
		
			# Checkboxes in rails will only return a variable if checked
			if policy.blank?
				@themes = Theme.all
				format.html { 
					flash[:notice] = 'You must agree to the privacy policy.'
					render action: "new", layout:"login" 
				}
			
			elsif @user.save
				begin
					UserMailer.registration_confirmation(@user).deliver

					LogsController.createUser(@user)
					
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

	#Updates user.
	def update
		respond_to do |format|
			if (not @current_user.id == @user.id) && (not @current_user.is_administrator?)
				format.html {redirect_to root_path, notice: 'Access Denied.'}
				
			elsif @user.update_attributes(params[:user])
				LogsController.updateUser(@user)

				format.html { redirect_to @user, notice: 'User was successfully updated.' }
				format.json { head :no_content }
			else
				@themes = Theme.all
				format.html { render action: "edit" }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	#Destroys user.
	def destroy
		LogsController.destroyUser(@user)

		@user.destroy

		respond_to do |format|
			format.html { redirect_to users_url }
			format.json { head :no_content }
		end
	end

	# GET /users/#/confirm/#
	#Confirms the confirmation code sent in the email.
	def confirm
		confirm = params[:confirm]
		
		respond_to do |format|
			if @user.confirmation_code == confirm
				@user.enabled = true
			else
				@themes = Theme.all
				format.html { redirect_to login_path, layout:"login", notice: 'Incorrect confirmation code.' }
			end
		
			if @user.save
				# Add log
				LogsController.activateUser(@user)

				format.html { redirect_to login_path, layout:"login", notice: 'User was enabled.'}
			else
				@themes = Theme.all
				format.html { redirect_to login_path, layout:"login", notice: 'Unable to save the user.' }
			end
		end
	end
	
	# GET /users/#/confirm/#
	#Confirms admin confirmation code.
	def admin_confirm
		@user.enabled = true
		
		respond_to do |format|
			if @user.save
				format.html { redirect_to users_url, notice: 'The user was enabled successfully!'}
			else
				@themes = Theme.all
				format.html { redirect_to users_url, notice: 'There was a problem enabling the user.'}
			end
		end
	end
	
	# POST /users/add_role/1
	#Renders add role page.
	def add_role
		@roles = Role.all

		respond_to do |format|
			format.html
		end
	end

	#Sets current session's user id to the id in the params.
	#User will now see everything as if he were the specified user.
	def possess
		session[:user_id] = params[:id]
		
		redirect_to root_path
	end
end
