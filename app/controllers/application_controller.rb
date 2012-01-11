class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_db
  
private
  def need_auth
    redirect_to session_index_path unless session[:uid]    
  end
  
  def load_db
    @bdb = $connection.db("bridgeo")
    @userdb = nil
    @host = request.env["HTTP_HOST"].split(".")[-2..-1].join(".")
    Rails.logger.debug { "Host: #{@host}" }
    if @account = @bdb.collection("accounts").find_one({ :host => @host })
      if Rails.env == "production"
        $connection.add_auth(account["db"], account["db_user"], account["db_pass"])
        $connection.apply_saved_authentication()
      end
      @db = $connection.db(@account["db"])
    end
  end
end
