class ApplicationController < ActionController::API
  include ActionController::Serialization

  before_action :add_allow_credentials_headers
  
def add_allow_credentials_headers                                                                                                                                                       
  response.headers["Access-Control-Allow-Origin"] = request.headers["Origin"] || "*"                                                                                                                                                                                                     
  response.headers["Access-Control-Allow-Credentials"] = "true"                                                                                                                                                                                                                          
end 

def options                                                                                                                                                                                                                                                                              
  head :status => 200, :"Access-Control-Allow-Headers" => "accept, content-type"                                                                                                                                                                                                         
end

end
