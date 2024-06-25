class HomepageController < ApplicationController
  def index
    @count = Stay.count
  end
end
