@connection = ReplSetConnection.new(['mongo1.mongood.com', 27017], ['mongo2.mongood.com', 27017], ['mongo3.mongood.com', 27017], :read_secondary => true)
@connection.add_auth("bridgeo", "loth9ohlieNaeD1YahsiebeXaimohbaey3thoh3ooR", "queng3leNeeSiph4iejaeRawain4sheVohpieSeec7")
@connection.apply_saved_authentication()