class HomeController < ApplicationController
  before_filter :need_auth
  
  def index
    unless @db.collection("layouts").find_one().nil?
      # If there is no layout then create a new one
      l = {}
      
    end
    # If there is no page then create a new one with default layout
    
    # Then load page structure
    # And page data
    render :text => "Coming soon"
  end

end
