ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "baregrades.com",  
  :user_name            => "admin@baregrades.com",  
  :password             => "AccessCodevs.Blue2013",  
  :authentication       => :plain,  
  :tls					=> true,
  :enable_starttls_auto => true  
}