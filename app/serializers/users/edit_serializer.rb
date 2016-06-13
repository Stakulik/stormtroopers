class Users::EditSerializer < UserSerializer
  attributes :email, :first_name, :last_name, :password, :password_confirmation, :current_password

  def password
    ""
  end

  def password_confirmation
    ""
  end

  def current_password
    ""
  end

end
