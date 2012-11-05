class UserMailer < ActionMailer::Base
	default :to => "admin@baregrades.com"
	
	def feedback(email, topic, description)
	
		mail(:to 		=> "admin@baregrades.com",
			 :from 		=> email,
			 :subject 	=> topic,
			 :body 		=> description)
	end
end