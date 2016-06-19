module Exceptions
  class AccessDeniedError < StandardError
  end

  class NotAuthenticatedError < StandardError
  end
  
  class AuthenticationTimeoutError < StandardError
  end

  class WrongClientsIpError < StandardError
  end
end