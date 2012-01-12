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
      # load html content and remove all <head></head> data and only add bridgeo js file
      l["html"] = IO.read("#{Rails.root}/template/index.html").gsub(/<head>([\w\W]*)<\/head>/i, "<head><script src='/assets/bridgeo.js' type='text/javascript'></script></head>")
      @db.collection("layouts").save(l)
      # Then create a new one with default layout
      page = YAML::load(IO.read("#{Rails.root}/template/data.yml"))
      @db.collection("pages").save(page)
      # Save first page in Account model
      @baccount["first_page"] = "/index.html"
      @bdb.collection("accounts").save(@baccount)
    end
    
    # Then load page structure
    # And page data
    redirect_to @baccount["first_page"]
  end
  
  def show
    @page = @db.collection("pages").find_one({ :url => "/#{params[:id]}.html" })
    @layout = @db.collection("layouts").find_one({ :name => @page["layout"] })
  end

  def loadlayout
    params[:id] ||= "index"
    @page = @db.collection("pages").find_one({ :url => "/#{params[:id]}.html" })
    @layout = @db.collection("layouts").find_one({ :name => @page["layout"] })
    # Create files in /private/ID/ if needez
    Dir.mkdir("#{Rails.root}/public/private/") rescue nil
    Dir.mkdir("#{Rails.root}/public/private/#{@account["_id"]}") rescue nil
    @css = ""
    @js = ""
    @layout["css"].each do |css|
      css.each do |k, v|
        if true || params[:refresh_assets]
          File.open("#{Rails.root}/public/private/#{@account["_id"]}/#{k.gsub("-css", ".css")}", "w") do |f|
            f.write v
          end
        end
        @css += "<link rel='stylesheet' href='/private/#{@account["_id"]}/#{k.gsub("-css", ".css")}' />"
      end
    end
    @layout["js"].each do |css|
      css.each do |k, v|
        if true || params[:refresh_assets]
          File.open("#{Rails.root}/public/private/#{@account["_id"]}/#{k.gsub("-js", ".js")}", "w") do |f|
            f.write v
          end
        end
        @js += "<script src='private/#{@account["_id"]}/#{k.gsub("-js", ".js")}' type='text/javascript' charset='utf-8'></script>"
      end
    end    
    respond_to do |format|
      format.js
    end    
  end
  
  def loadpage
    params[:id] ||= "index"
    @page = @db.collection("pages").find_one({ :url => "/#{params[:id]}.html" })
    render :json => @page.to_json
  end
  
  def getcontextmenu
    params[:page] ||= "index"
    @page = @db.collection("pages").find_one({ :url => "/#{params[:id]}.html" })
  end
  
  
end
