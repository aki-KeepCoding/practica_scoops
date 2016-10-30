var api = {
    "get": function (req, res, next) {
        var context = req.azureMobile;
        var query = {
            sql: "SELECT * FROM Noticias WHERE estado = 'Publicado'"
        };
        context.data.execute(query)
            .then(function(result){
                res.json(result);
            });
    }
}

module.exports = api;
