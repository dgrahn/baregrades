class RolesController < ApplicationController
	before_filter :check_admin_only
	#Checks if the user is an admin.
	#If not, redirect to root_path with access denied message.
	def check_admin_only
		# Check permissions
		if (not @current_user.is_administrator?)
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	# GET /roles
	# GET /roles.json
	#Renders up index page.
	def index
		@roles = Role.all

		respond_to do |format|
		format.html # index.html.erb
		format.json { render json: @roles }
		end
	end

	# GET /roles/1
	# GET /roles/1.json
	#Renders up show page.
	def show
		@role = Role.find(params[:id])

		respond_to do |format|
		format.html # show.html.erb
		format.json { render json: @role }
		end
	end

	# GET /roles/new
	# GET /roles/new.json
	#Renders new role page.
	def new
		@role = Role.new

		respond_to do |format|
		format.html # new.html.erb
		format.json { render json: @role }
		end
	end

	# GET /roles/1/edit
	#Renders edit page.
	def edit
		@role = Role.find(params[:id])
	end

	# POST /roles
	# POST /roles.json
	#Saves new role.
	def create
		@role = Role.new(params[:role])

		respond_to do |format|
			if @role.save
				format.html { redirect_to @role, notice: 'Role was successfully created.' }
				format.json { render json: @role, status: :created, location: @role }
			else
				format.html { render action: "new" }
				format.json { render json: @role.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /roles/1
	# PUT /roles/1.json
	#Updates role in the database.
	def update
		@role = Role.find(params[:id])

		respond_to do |format|
			if @role.update_attributes(params[:role])
				format.html { redirect_to @role, notice: 'Role was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @role.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /roles/1
	# DELETE /roles/1.json
	#Destroys role.
	def destroy
		@role = Role.find(params[:id])
		@role.destroy

		respond_to do |format|
			format.html { redirect_to roles_url }
			format.json { head :no_content }
		end
	end
end
