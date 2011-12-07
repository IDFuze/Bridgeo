$connection = Mongo::ReplSetConnection.new(['mongo1.mongood.com', 27017], ['mongo2.mongood.com', 27017], ['mongo3.mongood.com', 27017], :read => :secondary)
$connection.add_auth("bridgeo", "loth9ohlieNaeD1YahsiebeXaimohbaey3thoh3ooR", "queng3leNeeSiph4iejaeRawain4sheVohpieSeec7")
# TODO: We need to load another databases
# One db per website
$connection.apply_saved_authentication()
