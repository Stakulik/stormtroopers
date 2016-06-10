class RegistrationMailer < ApplicationMailer

  def confirmation_instructions(user)
    @user = user

    mail(to: @user.email, subject: "Welcome to Stormtroopers!")
  end

  def password_change

  end

  def reset_password_instructions

  end

  def unlock_instructions

  end

end
