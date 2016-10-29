//
//  NoticiaService.swift
//  Scoops
//
//  Created by Akixe on 29/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import Foundation


class NoticiaService {
    static public let azTableName = "Noticias"
    
    public static var client: MSClient = AzureServices.mobileAppClient
    
    public static func getAll(_ handler: @escaping (Noticias, Error?)->()) {
        let azNoticiasTable = client.table(withName: azTableName)
        var noticias : Noticias = []
        azNoticiasTable.read { (results, error) in
            if let _ = error {
                handler([], error)
                return
            }
            if let items = results {
                for item in items.items! {
                    noticias.append(Noticia(withDictionary: item as! [String: AnyObject]))
                }
                handler(noticias, nil)
            }
        }
    }
    
    
    public static func saveNoticia(_ noticia: Noticia, handler: @escaping (Dictionary<AnyHashable,Any>?, Error?)->()){
        let azNoticiasTable = client.table(withName: azTableName)
     
        azNoticiasTable.insert(noticia.toDict()){ (result, error) in
            if let _ = error {
                handler(nil, error)
                return
            }
            handler(result, nil)
        }

    }
    
    
}
