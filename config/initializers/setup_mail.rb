ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "baregrades.com",  
  :user_name            => "admin@baregrades.com",  
  :password             => "SecrePasswrdsArFun!",  
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}