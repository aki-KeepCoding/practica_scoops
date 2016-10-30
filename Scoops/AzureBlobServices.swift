//
//  AzureBlobServices.swift
//  Scoops
//
//  Created by Akixe on 29/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import Foundation


class AzureBlobServices {
    
    func getStorageAccount(credentials: AZSStorageCredentials = AzureServices.storageCredentials) -> AZSCloudStorageAccount?  {
        do {
            return try AZSCloudStorageAccount(credentials: credentials, useHttps: true)
        }catch let error {
            print(error)
            return nil
        }
    }
    
    func uploadImagen(imagen:UIImage, toContainer containerName: String, withCompletionHandler handler: @escaping (String?, Error?)->Void){
        guard let storageAccount = self.getStorageAccount() else {
            return
        }
            //self.navigationItem.rightBarButtonItem?.isEnabled = false
            //self.navigationItem.hidesBackButton = true
            
            let blobClient = storageAccount.getBlobClient()
            let container = blobClient?.containerReference(fromName: containerName)
            
            container?.createContainerIfNotExists(completionHandler: { (error, exists) in
                if let _ = error {
                    print(error)
                    return
                }
                
                let blockID = UUID().uuidString
                let imagenBlob = container?.blockBlobReference(fromName: blockID + ".jpg")
                
                imagenBlob?
                    .upload(from: UIImageJPEGRepresentation(imagen, 0.2)!,
                            completionHandler: { (error) in
                                if error != nil {
                                    handler(nil, error)
                                    return
                                }
                                let imageURL = AzureServices.storageAccountURL + "/" + containerName + "/" + blockID + ".jpg"
                                handler(imageURL, nil)
                })
            })
    }
    
    
    
}
