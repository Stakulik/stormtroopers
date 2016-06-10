class ApplicationMailer < ActionMailer::Base
  default from: "from@stormtroopers.herokuapp.com"
  layout "mailer"
end
