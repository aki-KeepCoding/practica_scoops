var express = require('express');
var azuremobileapps = require('azure-mobile-apps');


var app = express();
var mobile = azuremobileapps();


mobile.tables.import("./tables");
mobile.api.import("./api");
app.use(mobile);
console.log("======sdfasdfsaf")

app.listen(process.env.PORT || 3000);
