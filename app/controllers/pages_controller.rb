class PagesController < ApplicationController
  before_action :authenticate_request!

  def index
    render plain: "OK"
  end

end
