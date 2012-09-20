class AccessesController < ApplicationController
	def index
		@user = User.find(params[:user_id])
		@roles = @user.roles
		@all_access = Access.all
	end

	def new
		@user = User.find(params[:user_id])
		@access = Access.new
		@all_roles = Role.all
	end

	def create
		@user = User.find(params[:user_id])
		@access = Access.new(params[:access])

		respond_to do |format|
		  if @access.save
			format.html { redirect_to @user, notice: 'Access was successfully created.' }
		  else
			format.html { render action: "new" }
		  end
		end
	end

	def update
	end

	# DELETE /users/1/accesses
	def destroy
		@user = User.find(params[:user_id])
		@access = Access.find(params[:id])
		@access.destroy

		redirect_to @user, notice: 'Role was successfully removed.'
	end
end