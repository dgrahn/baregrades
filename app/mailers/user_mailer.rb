class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.feedback.subject
  #
  def feedback(email, topic, description)
	@email = email
    @topic = topic
	@description = description

    mail(:to => "jtengel08@gmail.com", :from => @email, :subject => @topic, :body => @description)
  end
end
