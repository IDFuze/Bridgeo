class HomeController < ApplicationController
  before_filter :need_auth
  layout nil
  
  def index
    unless @db.collection("layouts").find_one().nil?
      # If there is no layout then create a new one
      l = {}
      l["name"] = "website"
      l["html"] = "<!DOCTYPE html><html><head></head><body></body></html>"
      l["js"] = [{ "jquery" => "" }, { "somethingelse" => "" }]
      @db.collection("layouts").save(l)
      # If there is no page then create a new one with default layout
      page = {}
      page["url"] = "/index.html"
      page["metas"] = { :d => "Home page", :k => "home, page" }
      # Save first page in Account model
      @account["first_page"] = "/index.html"
      @bdb.collection("accounts").save(@account)
    end
    
    # Then load page structure
    # And page data
    render :text => "Coming soon"
  end

end
