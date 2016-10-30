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

enum Estado: String {
    case privado = "Privado"
    case publicable = "Publicable"
    case publicado = "Publicado"
}
class Noticia {
    var id: String = ""
    var titulo : String?
    var texto : String?
    var autor : String?
    var imagenURL : String?
    var valoracion : Int?
    var estado : Estado? // Privado | Publicable | Publicada
    
    init(id: String?,
         titulo: String,
         texto: String,
         autor: String,
         imagenURL : String,
         valoracion: Int? = 0,
         estado: Estado? = Estado.privado) {
        if let _id = id {
            self.id = _id
        }
        self.titulo = titulo
        self.texto = texto
        self.autor = autor
        self.imagenURL = imagenURL
        if let _valoracion = valoracion {
            self.valoracion = _valoracion
        } else {
            self.valoracion = 0
        }
        if let _estado = estado  {
            self.estado = _estado
        } else {
            self.estado = Estado.privado
        }
        
    }
    convenience init(withAutor autor : String) {
        self.init(id: nil,
                  titulo: "",
                  texto: "",
                  autor: "",
                  imagenURL: "",
                  valoracion: 0,
                  estado: Estado.privado)
    }
    
    convenience init(withDictionary noticiaDict: NoticiaDict) {
        var id = ""
        var titulo = ""
        var texto = ""
        var autor = "Anónimo"
        var imagenURL = ""
        var valoracion = 0
        var estado = Estado.privado
        if let _id = noticiaDict["id"] as? String {
            id = _id
        }
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
        
        if let _valoracion = noticiaDict["valoracion"] as? Int {
            valoracion = _valoracion
        }
        
        if let _estado = noticiaDict["estado"] as? String {
            estado = Estado(rawValue : _estado)!
        }
        self.init(id: id,
                  titulo: titulo,
                  texto: texto,
                  autor: autor,
                  imagenURL: imagenURL,
                  valoracion: valoracion,
                  estado: estado)
    }
    
    
    public func toDict() -> NoticiaDict {
        let noticiaDict : NoticiaDict = [
            "id": id as AnyObject,
            "titulo" : self.titulo! as AnyObject,
            "texto" : self.texto! as AnyObject,
            "autor" : self.autor! as AnyObject,
            "imagenURL" : self.imagenURL! as AnyObject,
            "valoracion" : self.valoracion! as AnyObject,
            "estado" : self.estado!.rawValue as AnyObject
        ]
        
        return noticiaDict
    }
    
    public func cambiarEstado() {
        if self.estado == Estado.privado {
            self.estado = Estado.publicable
        } else {
            self.estado = Estado.privado
        }
    }
}
