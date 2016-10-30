var azureMobileApps = require('azure-mobile-apps');

var logger = azureMobileApps.logger;

var api = {
    "get": function (req, res, next) {
        var context = req.azureMobile;
        logger.info(req.query);
        var sql =  `SELECT valoracion FROM UsuarioValoracionNoticia 
                        WHERE USER_ID = '${req.query.USER_ID}' AND 
                                noticia_id = '${req.query.noticia_id}'`;
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