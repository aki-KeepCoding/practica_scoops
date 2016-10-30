var azureMobileApps = require('azure-mobile-apps');

var logger = azureMobileApps.logger;

var api = {
    "get": function (req, res, next) {
        var context = req.azureMobile;
        logger.info(req.query);
        var sql =  `INSERT INTO NoticiasStats (USER_ID, noticia_id)  
					   VALUES ('${req.query.USER_ID}','${req.query.noticia_id}');`;
        logger.info(sql)
        var query = {
            sql: sql
        };
        context.data.execute(query)
            .then(function(result){
                logger.info("exec", result);
                res.json(result);
            })
            .catch(function(error){
                logger.info("error", error)
            });
    }
}

module.exports = api;