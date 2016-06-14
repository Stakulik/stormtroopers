class RegistrationMailer < ApplicationMailer

  def confirmation_instructions(user)
    @user = user

    mail(to: @user.email, subject: "Confirm your Stormtroopers account")
  end

  def reset_password_instructions(user)
    @user = user

    mail(to: @user.email, subject: "Reset password instructions")
  end

end
