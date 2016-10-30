var azureMobileApps = require('azure-mobile-apps');

var table = azureMobileApps.table();
var logger = azureMobileApps.logger;

//var table = module.exports = require('azure-mobile-apps').table();

// table.read(function (context) {
//     return context.execute();
// });

// table.read.use(customMiddleware, table.operation);


table.insert(function(context){
	context.item.user_id = context.user.id;
	return context.execute();
});

table.read(function(context){
	context.query.where({
		user_id: context.user.id
	});
	return context.execute();
});


module.exports = table;