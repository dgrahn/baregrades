class LogsController < ApplicationController
	# Reputation Point Values
	@@addCourse 			= 50
	@@joinCourse 			= 15
	@@updateCourse 			= 5
	@@leaveCourse 			= -15
	@@destroyCourse 		= -50

	@@createAssignmentType 	= 10
	@@updateAssignmentType 	= 5
	@@destroyAssignmentType = 2

	@@createAssignment		= 5
	@@updateAssignment		= 2
	@@destroyAssignment		= -5

	@@createUser			= 0
	@@activateUser			= 10
	@@updateUser			= 1
	@@destroyUser			= 0

	@@updateGradeScale		= 2

	@@createGrade			= 2
	@@updateGrade			= 0
	@@destroyGrade			= -2

	@@login					= 0
	@@logout				= 0

	private
	def self.createLog(user)
		log = Log.new
		log.user = user
		return log
	end

	private
	def self.createCourseLog(user, course)
		log = createLog(user)
		log.course = course
		return log
	end

	private
	def self.createAssignmentTypeLog(user, assignment_type)
		log = createCourseLog(user, assignment_type.course)
		log.assignment_type = assignment_type
		return log
	end

	private
	def self.createAssignmentLog(user, assignment)
		log = createAssignmentTypeLog(user, assignment.assignment_type)
		log.assignment = assignment
		return log
	end

	private
	def self.createGradeLog(user, grade)
		log = createAssignmentLog(user, grade.assignment)
		log.grade = grade
		return log
	end

	def self.joinCourse(user, course)
		log = createCourseLog(user, course)
		log.comments = "#{log.user.name} joined the course '#{course.name}'"
		log.save
		
		user.add_reputation(@@joinCourse)
	end
	
	def self.leaveCourse(user, course)
		log = createCourseLog(user, course)
		log.comments = "#{log.user.name} left the course '#{course.name}'"
		log.save

		user.add_reputation(@@leaveCourse)
	end
	
	def self.addCourse(user, course)
		log = createCourseLog(user, course)
		log.comments = "#{user.name} created course '#{course.name}'"
		log.save
		
		user.add_reputation(@@addCourse)
	end

	def self.updateCourse(user, course)
		log = createCourseLog(user, course)
		log.comments = "#{user.name} updated course '#{course.name}'"
		log.save

		user.add_reputation(@@updateCourse)
	end

	def self.destroyCourse(user, course)
		log = createCourseLog(user, course)
		log.comments = "#{user.name} destroyed course '#{course.name}'"
		log.save

		user.add_reputation(@@destroyCourse)
	end

	def self.createAssignmentType(user, assignment_type)
		log = createAssignmentTypeLog(user, assignment_type)
		log.comments = "#{user.name} created assignment type '#{assignment_type.name}' in '#{log.course.name}'"
		log.save

		user.add_reputation(@@createAssignmentType)
	end

	def self.updateAssignmentType(user, assignment_type)
		log = createAssignmentTypeLog(user, assignment_type)
		log.comments = "#{user.name} updated assignment type '#{assignment_type.name}' in '#{log.course.name}'"
		log.save

		user.add_reputation(@@updateAssignmentType)
	end

	def self.destroyAssignmentType(user, assignment_type)
		log = createAssignmentTypeLog(user, assignment_type)
		log.comments = "#{user.name} destroyed assignment type '#{assignment_type.name}' in '#{log.course.name}'"
		log.save

		user.add_reputation(@@destroyAssignmentType)
	end

	def self.createAssignment(user, assignment)
		log = createAssignmentLog(user, assignment)
		log.comments = "#{user.name} created assignment '#{assignment.name}' in '#{log.course.name}'"
		log.save

		user.add_reputation(@@createAssignment)
	end
	
	def self.updateAssignment(user, assignment)
		comment = "Another student has changed <strong>#{assignment.name}</strong> in <strong>#{assignment.course.name}</strong>."

		if assignment.worth_changed?
			comment += " It is now worth <strong>#{assignment.worth} points</strong>."
		end

		if assignment.due_date_changed?
			comment += " It is now due on <strong>#{assignment.due_date}</strong>."
		end

		puts comment
		assignment.course.users.each do |use|
			if use != user
				notif = Notification.new
				notif.user = use
				notif.assignment = assignment
				notif.comments = comment
				notif.save
			end
		end

		log = createAssignmentLog(user, assignment)
		log.comments = "#{user.name} updated assignment '#{assignment.name}' in '#{log.course.name}'"
		log.save

		user.add_reputation(@@updateAssignment)

	end
	
	def self.destroyAssignment(user, assignment)
		log = createAssignmentLog(user, assignment)
		log.comments = "#{user.name} destroyed assignment '#{assignment.name}' in '#{log.course.name}'"
		log.save

		user.add_reputation(@@destroyAssignment)
	end
	
	def self.createUser(user)
		log = createLog(user)
		log.comments = "#{user.name} registered."
		log.save

		user.add_reputation(@@createUser)
	end
	
	def self.activateUser(user)
		log = createLog(user)
		log.comments = "#{user.name} activated."
		log.save

		user.add_reputation(@@activateUser)
	end
	
	def self.updateUser(user)
		log = createLog(user)
		log.comments = "#{user.name} info updated."
		log.save

		user.add_reputation(@@updateUser)
	end

	def self.destroyUser(user)
		log = createLog(user)
		log.comments = "#{user.name} destroyed."
		log.save

		user.add_reputation(@@destroyUser)
	end

	def self.login(user)
		log = createLog(user)
		log.comments = "#{user.name} logged in."
		log.save

		user.add_reputation(@@login)
	end

	def self.logout(user)
		log = createLog(user)
		log.comments = "#{user.name} logged out."
		log.save

		user.add_reputation(@@logout)
	end

	def self.updateGradeScale(user, course)
		log = createCourseLog(user, course)
		log.comments = "#{user.name} updated grade scale to '#{course.name}'"
		log.save

		user.add_reputation(@@updateGradeScale)
	end

	def self.createGrade(user, grade)
		log = createGradeLog(user, grade)
		log.comments = "#{user.name} added grade to assignment '#{log.assignment.name}' in '#{log.course.name}'"
		log.save

		user.add_reputation(@@createGrade)
	end
	
	def self.updateGrade(user, grade)
		log = createGradeLog(user, grade)
		log.comments = "#{user.name} updated grade to assignment '#{log.assignment.name}' in '#{log.course.name}'"
		log.save

		user.add_reputation(@@updateGrade)
	end

	def self.destroyGrade(user, grade)
		log = createGradeLog(user, grade)
		log.comments = "#{user.name} destroyed grade to assignment '#{log.assignment.name}' in '#{log.course.name}'"
		log.save

		user.add_reputation(@@destroyGrade)
	end
end