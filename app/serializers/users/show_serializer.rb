class Users::ShowSerializer < UserSerializer
  attributes :email, :first_name, :last_name, :name, :current_password

  def name
    "#{object.first_name} #{object.last_name}"
  end

  def current_password
    ""
  end
end
