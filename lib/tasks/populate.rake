namespace :db do
	desc "Populate the database"
	task :populate => :environment do
		require 'rubygems'
		require 'faker'
		require 'populator'
		puts "Populating..."
		
		# Amount of data to generate
		amount = 20
		
		# Role Sample Data
		Role.create(:id => 1, :name => "Administrator")
		Role.create(:id => 2, :name => "Advisor")
		Role.create(:id => 3, :name => "Professor")
		Role.create(:id => 4, :name => "Teachers Aid")
		Role.create(:id => 5, :name => "Student")
		
		# User Generated Sample Data
		User.populate amount do |u|
			u.email 		= Faker::Internet.email
			u.first_name 	= Faker::Name.first_name
			u.last_name 	= Faker::Name.last_name
			u.middle_name 	= Faker::Name.first_name
			u.username 		= Populator.words(1)
			#u.password 			 = 'password'
			#u.password_confirmation = 'password'
		end

		Assignment.populate amount do |as|
			as.description 	= Populator.sentences(2..10)
			as.name 		= Populator.words(1)
			as.worth		= rand(1..100)
			as.assignment_type_id = rand(1..amount)
		end

		# Course Generated Sample Data
		i = 2
		Course.populate amount do |cr|
			cr.credits 			= rand(1..10) + (rand(0..1) * 0.5)
			cr.description 		= Populator.sentences(2..10)
			cr.name 			= Populator.words(1).titleize
			cr.pin 				= rand(0..100000)
			cr.points_based 	= rand(0..1)
			cr.section 			= rand(1..10)
			cr.student_managed 	= rand(0..1)
			
			cr.identifier 	= ''
			charLength 		= rand(2..4)
			charLength.times do |t|
				cr.identifier = cr.identifier + Populator.interpret_value("A" .. "Z").to_s
			end
			
			cr.identifier 	= cr.identifier + "-" +
							  rand(0..9).to_s + rand(0..9).to_s + rand(0..9).to_s + rand(0..9).to_s
			
			# GradeScale Generated Sample Data
			gs = GradeScale.new()
			gs.course_id = i
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
			gs.save
			
			i = i + 1
		end
		
		# Access Generated Sample Data
		Access.populate amount do |ac|
			ac.user_id = rand(1..amount)
			ac.role_id = rand(1..5)
			ac.course_id = rand(1..amount)
		end
		
		# AssignmentType Generated Sample Data
		AssignmentType.populate amount do |at|
			at.description 	= Populator.sentences(2..10)
			at.name 		= Populator.words(1)
			at.worth		= rand(1..100)
			at.course_id 	= rand(1..amount)
		end
		
		# Assignment Generated Sample Data
		Assignment.populate amount do |as|
			as.description 	= Populator.sentences(2..10)
			as.name 		= Populator.words(1)
			as.worth		= rand(1..100)
			as.assignment_type_id = rand(1..amount)
		end
		
		# Grade Generated Sample Data
		Grade.populate amount do |gr|
			gr.grade 			= rand(1..1000000000000)
			gr.assignment_id	= rand(1..amount)
			gr.user_id 			= rand(1..amount)
		end
		
		puts "Done!"
	end
	
	desc "Erase the database"
	task :erase => :environment do
		puts "Erasing..."
		
		[Access, Assignment, AssignmentType, Course, Grade, GradeScale, Role, User].each(&:delete_all)
		
		puts "Done!"
	end

	task :parallel => :environment do
		@parallel = Course.create(
			:credits 			=> 3.0,
			:description 		=> "Program applications that can run on more than one processor",
			:identifier 		=> "CS-4210",
			:name 				=> "Parallel Computing",
			:pin 				=> 1111,
			:points_based 		=> false,
			:section 			=> 01,
			:student_managed 	=> true)
			
			@homework = AssignmentType.create(
				:name 			=> "Homework",
				:description 	=> "The worst part of the course.",
				:worth 			=> 15,
				:course_id 		=> @parallel.id)
				
				Assignment.create(
					:name				=> "Homework 1",
					:description		=> "Your standard homework.",
					:worth				=> 50,
					:assignment_type_id => @homework.id)

				Assignment.create(
					:name				=> "Homework 2",
					:description		=> "Your standard homework.",
					:worth				=> 50,
					:assignment_type_id => @homework.id)

				Assignment.create(
					:name				=> "Homework 3",
					:description		=> "Your standard homework.",
					:worth				=> 50,
					:assignment_type_id => @homework.id)

			@projects = AssignmentType.create(
				:name 			=> "Projects",
				:description 	=> "The bread and butter of the course.",
				:worth 			=> 60,
				:course_id 		=> @parallel.id)

				Assignment.create(
					:name 				=> "Project 1",
					:description		=> "It's a project. Written in parallel. With analysis.",
					:worth				=> 100,
					:assignment_type_id => @projects.id)
					
				Assignment.create(
					:name 				=> "Project 2",
					:description		=> "It's a project. Written in parallel. With analysis.",
					:worth				=> 100,
					:assignment_type_id => @projects.id)
					
				Assignment.create(
					:name 				=> "Project 3",
					:description		=> "It's a project. Written in parallel. With analysis.",
					:worth				=> 100,
					:assignment_type_id => @projects.id)
					
				Assignment.create(
					:name 				=> "Project 4",
					:description		=> "It's a project. Written in parallel. With analysis.",
					:worth				=> 100,
					:assignment_type_id => @projects.id)
					
				Assignment.create(
					:name 				=> "Project 5",
					:description		=> "It's a project. Written in parallel. With analysis.",
					:worth				=> 100,
					:assignment_type_id => @projects.id)
				
				Assignment.create(
					:name 				=> "Project 6",
					:description		=> "It's a project. Written in parallel. With analysis.",
					:worth				=> 100,
					:assignment_type_id => @projects.id)

			@exams = AssignmentType.create(
				:name 			=> "Exams",
				:description 	=> "Take home and extremely long, but well done.",
				:worth 			=> 30,
				:course_id 		=> @parallel.id)

				Assignment.create(
					:name 				=> "Midterm",
					:description		=> "Gallagher has great tests. You learn a lot, but it takes a long time.",
					:worth				=> 100,
					:assignment_type_id => @exams.id)

				Assignment.create(
					:name 				=> "Final",
					:description		=> "Gallagher has great tests. You learn a lot, but it takes a long time.",
					:worth				=> 100,
					:assignment_type_id => @exams.id)
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
					:last_name 		=> 'Engel',
					:username 		=> 'jengel', 
					:password 		=> 'accesscode',
					:password_confirmation => 'accesscode',
					:email  		=> 'jengel@cedarville.edu')
					
		a3 = User.create(:first_name 	=> 'Matthew',
					:middle_name 	=> '?',
					:last_name 		=> 'Brooker',
					:username 		=> 'matBro', 
					:password 		=> 'password',
					:password_confirmation => 'password',
					:email  		=> 'mbrooker@cedarville.edu')
		
		# Role Sample Data
		Role.create(:id => 1, :name => "Administrator")
		Role.create(:id => 2, :name => "Advisor")
		Role.create(:id => 3, :name => "Professor")
		Role.create(:id => 4, :name => "Teachers Aid")
		Role.create(:id => 5, :name => "Student")
		
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