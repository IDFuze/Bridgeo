class SessionController < ApplicationController
  
  def index
    #redirect_to :root
    @account = @db.collection("accounts").find_one({ host: request.env["SERVER_NAME"] })
  end
  
  def signin
    account = @userdb.collection("accounts").find_one({ host: request.env["SERVER_NAME"] })
    Rails.logger.debug { " ACCOUNT: #{account.inspect}" }
    if account.nil?
      bridgeo_account = @db.collection("accounts").find_one({ host: request.env["SERVER_NAME"] })
      unless bridgeo_account.nil?
        # create first user if needed
        account = {}
        account[:name] = bridgeo_account[:name]
        account[:email] = bridgeo_account[:email]
        account[:login] = bridgeo_account[:login]
        account[:pass] = bridgeo_account[:pass]
        account[:roles] = ["admin"]
        account = @userdb.collection("accounts").insert(account)
        session[:uid] = account
      end
    else
      session[:uid] = account[:_id]
    end
    Rails.logger.debug { "Session: #{session.inspect}" }
    redirect_to :root
  end
  
  def signup
    host = request.env["SERVER_NAME"]
    account = @db.collection("accounts").find_one({ host: host })
    if account.nil?
      # create the account
      account = {}
      account[:name] = params[:signup][:name]
      account[:email] = params[:signup][:email]
      account[:login] = params[:signup][:login]
      account[:pass] = BCrypt::Password.create params[:signup][:password]
      account[:host] = host
      account[:db] = params[:signup][:db]
      account[:db_user] = params[:signup][:db_user]
      account[:db_pass] = params[:signup][:db_pass]
      @db.collection("accounts").insert(account)
    end
    
    redirect_to :root
  end
  
  def lost_password
    redirect_to :root
  end
  
  def logout
    reset_session
    redirect_to :root
  end
end
