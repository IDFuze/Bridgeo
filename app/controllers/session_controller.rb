class SessionController < ApplicationController
  
  def index
    #redirect_to :root
    @account = @db.collection("accounts").find_one({ host: request["SERVER_NAME"] })
  end
  
  def signin
    redirect_to :root
  end
  
  def signup
    host = request["SERVER_NAME"]
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
end
