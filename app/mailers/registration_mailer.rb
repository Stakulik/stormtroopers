class RegistrationMailer < ApplicationMailer

  def confirmation_instructions(user)
    @user = user

    mail(to: @user.email, subject: "Welcome to Stormtroopers!")
  end

  def reset_password_instructions(user)
    @user = user

    mail(to: @user.email, subject: "Reset password instructions")
  end

end
