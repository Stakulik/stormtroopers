class Users::ShowSerializer < UserSerializer
  attributes :email, :name

  def name
    "#{object.first_name} #{object.last_name}"
  end

end
