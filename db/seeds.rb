# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create(id: 1, name: "Administrator")
Role.create(id: 2, name: "Advisor")
Role.create(id: 3, name: "Professor")
Role.create(id: 4, name: "Teachers Aid")
Role.create(id: 5, name: "Student")

Theme.create(name: "Pond", 				css_class: "pond")
Theme.create(name: "Goldfish",			css_class: "goldfish")
Theme.create(name: "Snow Purple", 		css_class: "snowpurple")
Theme.create(name: "Whiteness",			css_class: "whiteness")
Theme.create(name: "Condensed Milk",	css_class: "condensed")
Theme.create(name: "Dark Wood", 		css_class: "darkwood")
Theme.create(name: "Canvas",			css_class: "canvas")
Theme.create(name: "Citrus",			css_class: "citrus")
Theme.create(name: "Darkness",			css_class: "darkness")

root = User.create(first_name: "First",
					middle_name: "Middle",
					last_name: "Last",
					username: "Root",
					password: "root",
					password_confirmation: "root"
					email: "defaultroot@baregrades.com")

Access.create(user_id: root.id, role_id: 1)
			