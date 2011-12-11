$connection = nil

config_file = "#{Rails.root}/config/mongo.yml"
if File.exists? config_file 
  m = YAML::load(IO.read(config_file))
  if m[Rails.env]["server"].class == Array
    $connection = Mongo::ReplSetConnection.new(*m[Rails.env]["server"], :read => :secondary)
  else
    $connection = Mongo::Connection.new(m[Rails.env]["server"], nil, :logger => Rails.env == "development" ? Rails.logger : nil)
  end
  unless m[Rails.env]["user"].to_s.blank?
    $connection.add_auth(m[Rails.env]["database"], m[Rails.env]["user"], m[Rails.env]["pass"])
    $connection.apply_saved_authentication()
  end
end