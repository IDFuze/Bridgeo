class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_db
private
  def need_auth
    redirect_to session_index_path unless session[:uid]    
  end
  
  def load_db
    @db = $connection.db("bridgeo")
    @userdb = nil
    if session[:uid]
      account = @db.collection("accounts").find_one({ :_id => session[:uid] })
      if Rails.env == "production"
        $connection.add_auth(account.db, account.db_user, account.db_pass)
        $connection.apply_saved_authentication()
      end
      @userdb = $connection.db(account.db)
    end
  end
end
