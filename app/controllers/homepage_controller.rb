class HomepageController < ApplicationController
  def index
    @count = Stay.enabled.count
    session[:email] = nil
  end
end
