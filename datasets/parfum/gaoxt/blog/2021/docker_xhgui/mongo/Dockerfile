FROM mongo:4.0.21


# use tideways_xhprof
# db.results.ensureIndex( { 'meta.SERVER.REQUEST_TIME' : -1 },{background:true} )
# db.results.ensureIndex( { 'profile.main().wt' : -1 } )
# db.results.ensureIndex( { 'profile.main().mu' : -1 } )
# db.results.ensureIndex( { 'profile.main().cpu' : -1 } )
# db.results.ensureIndex( { 'meta.url' : 1 } )
# db.results.ensureIndex( { 'meta.simple_url' : 1 } )
# db.results.ensureIndex( { "meta.request_ts" : 1 }, { expireAfterSeconds : 3600*24*7 ,background:true})  5天数据过期
# db.results.ensureIndex( { 'meta.userId' : 1 } )
# db.results.ensureIndex( { 'meta.SERVER.REQUEST_TIME' : 1 } )
# db.results.getIndexes()


# use tideways_xhprof
# db.dropDatabase();


# db.results.find({ "meta.request_ts" : { $gte:ISODate("2021-06-07")}}).count()
# db.results.deleteMany({ "meta.request_ts" : { $gte:ISODate("2021-06-15")}})