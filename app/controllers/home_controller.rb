class HomeController < ApplicationController
  before_filter :need_auth
  layout nil
  
  def index
    if @db.collection("layouts").find_one().nil?
      # If there is no layout then create a new one from the template
      l = {}
      l["js"] = []
      l["css"] = []
      l["name"] = "website"
      Dir.entries("#{Rails.root}/template/js/").each do |file|
        unless [".", ".."].include? file
          l["js"] << { "#{file.gsub(".","-")}" => "#{IO.read("#{Rails.root}/template/js/#{file}")}" }
        end
      end
      Dir.entries("#{Rails.root}/template/css/").each do |file|
        unless [".", ".."].include? file
          l["css"] << { "#{file.gsub(".","-")}" => "#{IO.read("#{Rails.root}/template/css/#{file}")}" }
        end
      end
      l["html"] = IO.read("#{Rails.root}/template/index.html")
      @db.collection("layouts").save(l)
      # If there is no page then create a new one with default layout
      page = YAML::load(IO.read("#{Rails.root}/template/data.yml"))
      @db.collection("pages").save(page)
      # Save first page in Account model
      @account["first_page"] = "/index.html"
      @bdb.collection("accounts").save(@account)
    end
    
    # Then load page structure
    # And page data
    render :text => "Coming soon"
  end

end
