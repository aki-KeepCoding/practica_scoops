//
//  AzureService.swift
//  Scoops
//
//  Created by Akixe on 28/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import Foundation


class AzureServices {
    static public let mobileAppURL = "https://kcmbaas-app.azurewebsites.net"
    static public let storageAccountURL = "https://kcmbaas.blob.core.windows.net/"
    static public let mobileAppClient = MSClient(applicationURL: URL(string: AzureServices.mobileAppURL)!)
    static public let storageContainerName = "container"
    static public let storageCredentials = AZSStorageCredentials(accountName: "kcmbaas",
                                                                 accountKey: "wy57QbQ6koD7K7DjbJo53xWG6R4nBH6ibHhLDbsogTiHFv2P17cCi7y9sIgVxloq2FbZt/epEhzsZaqhLJpe9w==")
}
