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
    
    public func getNoticiasLector(_ handler: @escaping (Noticias, Error?)->()){
        var noticias : Noticias = []
        client.invokeAPI("kcmbaasCAPI",
                              body: nil,
                              httpMethod: "GET",
                              parameters: nil,
                              headers: nil,
                              completion: { (result, response, error) in
                                print(result)
                                if let _ = error {
                                    handler([], error)
                                    return
                                }
                                if let _ = result {
                                    
                                    let json = result as! [NoticiaDict]
                                    for item in json {
                                        noticias.append(Noticia(withDictionary: item))
                                    }
                                    handler(noticias, nil)
                                }
            })
    }
    
    
    public func getStats(noticia: Noticia, _ handler: @escaping (Dictionary<String,AnyObject>?, Error?)->()){
        let params: Dictionary<String, AnyObject> = ["noticia_id": noticia.id as AnyObject]
        client.invokeAPI("kcmbaasGetNoticiaStats",
                         body: nil,
                         httpMethod: "GET",
                         parameters: params,
                         headers: nil,
                         completion: { (result, response, error) in
                            print(result)
                            if let _ = error {
                                handler(nil, error)
                                return
                            }
                            if let _ = result {
                                let json = result as! [Dictionary<String,AnyObject>]
                                if json.count > 0 {
                                    handler(json.first!, nil)
                                    return
                                }
                            }
        })
    }
    
    public func valorar(valor: Int, noticia: Noticia, _ handler: @escaping (String, Error?)->()){
        var userID:String;
        if let _userID = AzureServices.mobileAppClient.currentUser!.userId  {
            userID = _userID
            let params: Dictionary<String, AnyObject> = ["valoracion": valor as AnyObject,
                                                         "noticia_id": noticia.id as AnyObject,
                                                         "USER_ID":  userID as AnyObject]
            client.invokeAPI("kcmbaasValoracion",
                             body: nil,
                             httpMethod: "GET",
                             parameters: params,
                             headers: nil,
                             completion: { (result, response, error) in
                                print(result)
                                if let _ = error {
                                    handler("ko", error)
                                    return
                                }
                                handler("ok", nil)
            })
        } else {
            handler("ko", nil)
        }
    }
    
    public func getValoracion(noticia: Noticia, _ handler: @escaping (Int, Error?)->()){
        var userID:String;
        if let _userID = AzureServices.mobileAppClient.currentUser!.userId  {
            userID = _userID
            let params: Dictionary<String, AnyObject> = ["noticia_id": noticia.id as AnyObject,
                                                         "USER_ID":  userID as AnyObject]
            client.invokeAPI("kcmbaasUsuarioValoracion",
                             body: nil,
                             httpMethod: "GET",
                             parameters: params,
                             headers: nil,
                             completion: { (result, response, error) in
                                print(result)
                                print(error)
                                if let _ = error {
                                    handler(0, error)
                                    return
                                }
                                var valoracion = 0
                                if let _ = result {
                                    let json = result as! [Dictionary<String,AnyObject>]
                                    if json.count > 0 {
                                        
                                        if let _valoracion = json.first!["valoracion"] as? Int{
                                            valoracion = _valoracion
                                        }
                                    }
                                }
                                handler(valoracion, nil)
            })
        } else {
            handler(0, nil)
        }
    }
    
    public func addVisita(noticia:Noticia){
        var userID:String;
        if let _userID = AzureServices.mobileAppClient.currentUser!.userId  {
            userID = _userID
            let params: Dictionary<String, AnyObject> = ["noticia_id": noticia.id as AnyObject,
                                                         "USER_ID":  userID as AnyObject]
            client.invokeAPI("kcmbaasAddVisitaNoticia",
                             body: nil,
                             httpMethod: "GET",
                             parameters: params,
                             headers: nil,
                             completion: { (result, response, error) in
                                print(result)
                                print(error)
                                if let _ = error {
                                    print(error)
                                }
                                return
            })
        } else {
            return
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
