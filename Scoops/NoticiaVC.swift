//
//  NoticiaVC.swift
//  Scoops
//
//  Created by Akixe on 26/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import UIKit

class NoticiaVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var tituloView: UITextField!
    @IBOutlet weak var textoView: UITextView!
    @IBAction func setImagen(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    var flagUploadingImagen = false
    
    let imagePicker = UIImagePickerController()
    
    let model : Noticia
    
    var azClient: MSClient
    
    init(model:Noticia, azClient : MSClient = AzureServices.mobileAppClient) {
        self.model = model
        self.azClient = azClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save,
                                                                 target: self,
                                                                 action: #selector(NoticiaVC.save))
        syncModelToView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func syncModelToView () {
        if let _titulo = model.titulo {
            tituloView.text = _titulo
        }
        
        if let _texto = model.texto {
            textoView.text = _texto
        }
        
        if let imgURLString = model.imagenURL,
            let url = URL(string:imgURLString) {
            downloadImage(url: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.imagenView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func downloadImage(url: URL, handler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            handler(data, response, error)
        }.resume()
    }
    
    func syncViewToModel () {
        model.titulo = tituloView.text!
        model.texto = tituloView.text!
    }
    
    func save(){
        syncViewToModel()
        
        
        let alert = UIAlertController(title: "Guardando", message: "Guardando la noticia.", preferredStyle: .alert)
        
        present(alert, animated: true, completion:nil)
    
        NoticiaService.saveNoticia(model){ (result, error) in
            if let _ = error {
                print(error)
                return
            }
            print(result)
            alert.dismiss(animated: true, completion: nil)
            let _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    
    
    
    // MARK - BlobStorage
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagenSeleccionada = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagenView.image = imagenSeleccionada
            setupBlobStorage()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    var client : AZSCloudBlobClient?
    var container : AZSCloudBlobContainer?
    var connectionString = "DefaultEndpointsProtocol=https;AccountName=myaccount;AccountKey=myAccountKey=="
    
    
    func setupBlobStorage(){
        do {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.hidesBackButton = true
            
            let credentials = AZSStorageCredentials(accountName: "kcmbaas",
                                                    accountKey: "wy57QbQ6koD7K7DjbJo53xWG6R4nBH6ibHhLDbsogTiHFv2P17cCi7y9sIgVxloq2FbZt/epEhzsZaqhLJpe9w==")
            let account = try AZSCloudStorageAccount(credentials: credentials, useHttps: true)
            client = account.getBlobClient()
            container = client?.containerReference(fromName: "container")
            container?.createContainerIfNotExists(completionHandler: { (error, exists) in
                if let _ = error {
                    print(error)
                    return
                
                }
                
                
                
                guard let imagen = self.imagenView?.image else {
                    return
                }
                let blockID = UUID().uuidString
                let imagenBlob = self.container?.blockBlobReference(fromName: blockID + ".jpg")
                imagenBlob?.upload(from: UIImageJPEGRepresentation(imagen, 0.2)!,
                                   completionHandler: { (error) in
                                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                                    self.navigationItem.hidesBackButton = false
                                    
                                    if  error != nil {
                                        print(error)
                                        return
                                    }
                                    self.model.imagenURL = "https://kcmbaas.blob.core.windows.net/container/" + blockID + ".jpg"
                                    print(self.model.imagenURL)
                })
                

            })
        } catch let error {
            print(error)
            client = nil
        }
    }

}
