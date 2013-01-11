OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "baregrades.com",  
  :user_name            => "admin@baregrades.com",  
  :password             => "AccessCodevs.Blue2013",  
  :authentication       => :plain,  
  :enable_starttls_auto => true  
}