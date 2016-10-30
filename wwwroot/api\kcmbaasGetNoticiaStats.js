var azureMobileApps = require('azure-mobile-apps');

var logger = azureMobileApps.logger;

var api = {
    "get": function (req, res, next) {
        var context = req.azureMobile;
        logger.info(req.query);
        var sql =  `SELECT (SELECT COUNT(*) FROM NoticiasStats 
                        WHERE noticia_id = '${req.query.noticia_id}') AS visitas,
                        (SELECT COUNT(*) FROM UsuarioValoracionNoticia 
                            WHERE noticia_id = '${req.query.noticia_id}'
                                AND valoracion = 1) 
                                AS noMeGusta,
                         (SELECT COUNT(*) FROM UsuarioValoracionNoticia 
                               WHERE noticia_id = '${req.query.noticia_id}'
                                   AND valoracion = 2) 
                                AS meGusta,
                         (SELECT COUNT(*) FROM UsuarioValoracionNoticia 
                               WHERE noticia_id = '${req.query.noticia_id}'
                                   AND valoracion = 3) 
                                AS meEncanta
                        `;
        logger.info(sql);
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