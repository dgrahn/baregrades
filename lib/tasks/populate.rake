namespace :db do
	desc "Populate the database"
	task :populate => :environment do
		require 'rubygems'
		require 'faker'
		require 'populator'
		puts "Populating..."
		
		# Role Sample Data
		Role.create(:id => 1, :name => "Administrator")
		Role.create(:id => 2, :name => "Advisor")
		Role.create(:id => 3, :name => "Professor")
		Role.create(:id => 4, :name => "Teachers Aid")
		Role.create(:id => 5, :name => "Student")
		
		# User Generated Sample Data
		User.populate 100 do |u|
			u.email 		= Faker::Internet.email
			u.first_name 	= Faker::Name.first_name
			u.last_name 	= Faker::Name.last_name
			u.middle_name 	= Faker::Name.first_name
			u.username 		= Populator.words(1)
			#u.password 				= 'password'
			#u.password_confirmation = 'password'
		end
		
		# Course Generated Sample Data
		Course.populate 200 do |cr|
			cr.credits 			= rand(1..10) + (rand(0..1) * 0.5)
			cr.description 		= Populator.sentences(2..10)
			cr.identifier 		= Populator.interpret_value("A" .. "Z").to_s +
								  Populator.interpret_value("A" .. "Z").to_s +
								  Populator.interpret_value("A" .. "Z").to_s +
								  Populator.interpret_value("A" .. "Z").to_s +
								  rand(0..9).to_s + rand(0..9).to_s + rand(0..9).to_s + rand(0..9).to_s
								  
			cr.name 			= Populator.words(1)
			cr.pin 				= rand(0..100000)
			cr.points_based 	= rand(0..1)
			cr.section 			= rand(1..10)
			cr.student_managed 	= rand(0..1)
		end
		
		# Access Generated Sample Data
		Access.populate 200 do |ac|
			ac.user_id = rand(1..100)
			ac.role_id = rand(1..5)
			ac.course_id = rand(1..200)
		end
		
		# AssignmentType Generated Sample Data
		AssignmentType.populate 200 do |at|
			at.description 	= Populator.sentences(2..10)
			at.name 		= Populator.words(1)
			at.worth		= rand(1..1000000000000)
			at.course_id 	= rand(1..200)
		end
		
		# Assignment Generated Sample Data
		Assignment.populate 200 do |as|
			as.description 	= Populator.sentences(2..10)
			as.name 		= Populator.words(1)
			as.worth		= rand(1..100)
			as.assignment_type_id = rand(1..200)
		end
		
		# Grade Generated Sample Data
		Grade.populate 200 do |gr|
			gr.grade 			= rand(1..1000000000000)
			gr.assignment_id	= rand(1..200)
			gr.user_id 			= rand(1..100)
		end
		
		# GradeScale Generated Sample Data
		GradeScale.populate 200 do |gs|
			gs.course_id 	= rand(1..200)
			gs.a 		= rand(1..101)
			gs.a_minus	= rand(1..101)
			gs.a_plus 	= rand(1..101)
			gs.b		= rand(1..101)
			gs.b_minus	= rand(1..101)
			gs.b_plus	= rand(1..101)
			gs.c		= rand(1..101)
			gs.c_minus	= rand(1..101)
			gs.c_plus	= rand(1..101)
			gs.d		= rand(1..101)
			gs.d_minus	= rand(1..101)
			gs.d_plus	= rand(1..101)
			gs.f		= rand(1..101)
			gs.f_minus	= rand(1..101)
			gs.f_plus	= rand(1..101)
		end
		
		puts "Done!"
	end
	
	desc "Erase the database"
	task :erase => :environment do
		puts "Erasing..."
		
		[Access, Assignment, AssignmentType, Course, Grade, GradeScale, Role, User].each(&:delete_all)
		
		puts "Done!"
	end
	
	desc "Create Default Administrators"
	task :createAdmins => :environment do
		puts "Creating Admins ..."
		
		# Admin users
		a1 = User.create(:first_name 	=> 'Daniel',
					:middle_name 	=> 'James',
					:last_name 		=> 'Grahn',
					:username 		=> 'root', 
					:password 		=> 'licorice',
					:password_confirmation => 'licorice',
					:email  		=> 'dgrahn@cedarville.edu')
		
		a2 = User.create(:first_name 	=> 'Justin',
					:middle_name 	=> 'Tyler',
					:last_name 		=> 'engel',
					:username 		=> 'jengel', 
					:password 		=> 'password',
					:password_confirmation => 'password',
					:email  		=> 'jengel@cedarville.edu')
					
		a3 = User.create(:first_name 	=> 'Matthew',
					:middle_name 	=> '?',
					:last_name 		=> 'Brooker',
					:username 		=> 'matBro', 
					:password 		=> 'password',
					:password_confirmation => 'password',
					:email  		=> 'mbrooker@cedarville.edu')
		
		adminId = Role.find_by_name("Administrator").id
		Access.create(	:user_id => a1.attributes['id'],
						:role_id => adminId);
						
		Access.create(	:user_id => a2.attributes['id'],
						:role_id => adminId);
		
		Access.create(	:user_id => a3.attributes['id'],
						:role_id => adminId);
		puts "Done!"
	end
end