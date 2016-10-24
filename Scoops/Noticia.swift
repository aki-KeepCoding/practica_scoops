//
//  Noticia.swift
//  Scoops
//
//  Created by Akixe on 24/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import Foundation


class Noticia {
    let titulo : String?
    let texto : String?
    let autor : String?
    
    init(titulo: String, texto: String, autor: String) {
        self.titulo = titulo
        self.texto = texto
        self.autor = autor
    }
}
