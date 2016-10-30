//
//  NoticiaService.swift
//  Scoops
//
//  Created by Akixe on 29/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import Foundation


class NoticiaService {
    static let azTableName = "Noticias"
    let client: MSClient
    
    init(client: MSClient = AzureServices.mobileAppClient){
        self.client = client
    }
    
    
    public func getAll(_ handler: @escaping (Noticias, Error?)->()) {
        let azNoticiasTable = client.table(withName: NoticiaService.azTableName)
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
    
    
    public func saveNoticia(_ noticia: Noticia, handler: @escaping (Dictionary<AnyHashable,Any>?, Error?)->()){
        
        let azNoticiasTable = self.client.table(withName: NoticiaService.azTableName)
        var data = noticia.toDict()
        if noticia.id == "" {
            data.removeValue(forKey: "id")
            azNoticiasTable.insert(noticia.toDict()){ (result, error) in
                if let _ = error {
                    handler(nil, error)
                    return
                }
                handler(result, nil)
            }
        } else {
            azNoticiasTable.update(data){ (result, error) in
                if let _ = error {
                    handler(nil, error)
                    return
                }
                handler(result, nil)
            }
        }

    }
    
    public func downloadImage(url: URL, handler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            handler(data, response, error)
            }.resume()
    }
}
