class HomepageController < ApplicationController
  def index
    @count = Stay.count
    session[:email] = nil
  end
end
