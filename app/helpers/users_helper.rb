module UsersHelper
	def generate_random_password
		chars = ("a".."z").to_a + ("A".."Z").to_a
		password = chars[rand(chars.size-1)]
		chars += ("0".."9").to_a
		15.times do |i|
			password += chars[rand(chars.size-1)]
		end
		
		return password
	end
end
