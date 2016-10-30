//
//  DummyData.swift
//  Scoops
//
//  Created by Akixe on 28/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import Foundation


class DummyData {
    
    static public func generateDummyNoticias () -> [Noticia] {
        let not1 = Noticia(id: nil, titulo:"Noticia 1", texto: "Noticia de pega 1", autor: "Akixe", imagenURL: "", valoracion: 0, estado: .privado)
        let not2 = Noticia(id: nil, titulo:"Noticia 2", texto: "Noticia de pega 2", autor: "Ixiar", imagenURL: "", valoracion: 0, estado: .privado)
        let not3 = Noticia(id: nil, titulo:"Noticia 3", texto: "Noticia de pega 3", autor: "Laira", imagenURL: "", valoracion: 0, estado: .privado)
        let not4 = Noticia(id: nil, titulo:"Noticia 4", texto: "Noticia de pega 4", autor: "Jare", imagenURL: "", valoracion: 0, estado: .privado)
        
        return [not1, not2, not3, not4]
    }

}
