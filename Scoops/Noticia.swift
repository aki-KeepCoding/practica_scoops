//
//  Noticia.swift
//  Scoops
//
//  Created by Akixe on 24/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import Foundation

typealias NoticiaDict = Dictionary<String,AnyObject>
typealias Noticias = [Noticia]

class Noticia {
    var titulo : String?
    var texto : String?
    var autor : String?
    var imagenURL : String?
    
    init(titulo: String,
         texto: String,
         autor: String,
         imagenURL : String) {
        self.titulo = titulo
        self.texto = texto
        self.autor = autor
        self.imagenURL = imagenURL
    }
    convenience init(withAutor autor : String) {
        let titulo = ""
        let texto = ""
        let imagenURL = ""
        self.init(titulo: titulo,
                  texto: texto,
                  autor: autor,
                  imagenURL: imagenURL)
    }
    
    convenience init(withDictionary noticiaDict: NoticiaDict) {
        var titulo = ""
        var texto = ""
        var autor = "Anónimo"
        var imagenURL = ""
        if let _titulo = noticiaDict["titulo"] as? String {
            titulo = _titulo
        }
        if let _texto = noticiaDict["texto"] as? String {
            texto = _texto
        }
        if let _autor = noticiaDict["autor"] as? String {
            autor = _autor
        }
        if let _imagenURL = noticiaDict["imagenURL"] as? String {
            imagenURL = _imagenURL
        }
        self.init(titulo: titulo,
                  texto: texto,
                  autor: autor,
                  imagenURL: imagenURL)
    }
    
    
    public func toDict() -> NoticiaDict {
        let noticiaDict : NoticiaDict = [
            "titulo" : self.titulo! as AnyObject,
            "texto" : self.texto! as AnyObject,
            "autor" : self.autor! as AnyObject,
            "imagenURL" : self.imagenURL! as AnyObject,
            "valoracion" : 0 as AnyObject,
            "publicada" : false as AnyObject
        ]
        
        return noticiaDict
    }
    
}
