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
    let imagePicker = UIImagePickerController()
    
    
    var flagUploadingImagen = false
    var flagNuevaNoticia = false
    
    let model : Noticia
    let noticiaService : NoticiaService
    let blobService : AzureBlobServices
    
    init(model:Noticia,
         noticiaService : NoticiaService? = NoticiaService(),
         blobService: AzureBlobServices? = AzureBlobServices()) {
        self.model = model
        self.noticiaService = noticiaService!
        self.blobService = blobService!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

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
            noticiaService.downloadImage(url: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.imagenView.image = UIImage(data: data)
                }
            }
        }
    }
    
    
    
    func syncViewToModel () {
        model.titulo = tituloView.text!
        model.texto = textoView.text!
    }
    
    func save(){
        syncViewToModel()
        
        let alert = UIAlertController(title: "Guardando", message: "Guardando la noticia.", preferredStyle: .alert)
        present(alert, animated: true, completion:nil)
    
        noticiaService.saveNoticia(model){ (result, error) in
            if let _ = error {
                print(error)
                return
            }
            print(result)
            alert.dismiss(animated: true, completion: {
                let _ = self.navigationController?.popToRootViewController(animated: true)
            })
        }
        
    }
    
    
    
    // MARK - BlobStorage
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagenSeleccionada = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagenView.image = imagenSeleccionada
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.hidesBackButton = true
            
            blobService.uploadImagen(imagen: imagenSeleccionada,
                                     toContainer: AzureServices.storageContainerName ) { (imagenURL, error) in
                                        if let _ = error {
                                            print(error)
                                            return
                                        }
                                        self.model.imagenURL = imagenURL
                                        DispatchQueue.main.async {
                                            self.navigationItem.rightBarButtonItem?.isEnabled = true
                                            self.navigationItem.hidesBackButton = false
                                        }
                                        
                                        
                                        
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    

}
