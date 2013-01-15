class UsersController < ApplicationController
	include UsersHelper
	skip_before_filter :require_login, 	:only => [:new, :create, :confirm]
	before_filter :check_admin_only, 	:only => [:index, :courses, :destroy, :admin_confirm]
	before_filter :check_user, 			:only => [:edit, :update, :add_role]

	def check_admin_only
		# Check permissions
		if (not @current_user.is_administrator?)
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	def check_user
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user == @user)
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	def index
		@users = User.all

		respond_to do |format|
			format.html
			format.json { render json: @users }
		end
	end

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
		@user = User.find(params[:id])
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
					
					# Add log
					log = Log.new
					log.user = @user
					log.comments = "#{@user.name} registered."
					log.save
					
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
				# Add log
				log = Log.new
				log.user = @user
				log.comments = "#{@user.name} updated info."
				log.save

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

		# Add log
		log = Log.new
		log.user = @user
		log.comments = "#{@user.name} deleted."
		log.save

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
				# Add log
				log = Log.new
				log.user = user
				log.comments = "#{user.name} confirmed."
				log.save

				format.html { redirect_to login_path, layout:"login", notice: 'User was enabled.'}
			else
				@themes = Theme.all
				format.html { redirect_to login_path, layout:"login", notice: 'Unable to save the user.' }
			end
		end
	end
	
	# GET /users/#/confirm/#
	def admin_confirm
		user = User.find(params[:id])
		user.enabled = true
		
		respond_to do |format|
			if user.save
				format.html { redirect_to users_url, notice: 'The user was enabled successfully!'}
			else
				@themes = Theme.all
				format.html { redirect_to users_url, notice: 'There was a problem enabling the user.'}
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

	def possess
		if not @current_user.is_administrator?
			return
		end

		session[:user_id] = params[:id]
		
		redirect_to root_path
	end
end
