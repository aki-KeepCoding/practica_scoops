//
//  NoticiaLectorVC.swift
//  Scoops
//
//  Created by Akixe on 30/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import UIKit

class NoticiaLectorVC: UIViewController {
    let noticiaService : NoticiaService
    let blobService : AzureBlobServices
    
    let model : Noticia
    
    @IBOutlet weak var tituloView: UILabel!
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var textoView: UITextView!
    @IBOutlet weak var valorView: UISegmentedControl!
    
    @IBAction func valorar(_ sender: UISegmentedControl) {
        
        noticiaService.valorar(valor: sender.selectedSegmentIndex + 1, noticia: model){ (result, error) in
            print(result)
        }
    }
    @IBAction func valoracion(_ sender: UIBarButtonItem) {
        var i = sender.buttonGroup!.barButtonItems.index(of: sender) ?? -1
        i = i + 1
        
    }
    
    init(model:Noticia,
         noticiaService : NoticiaService? = NoticiaService(),
         blobService: AzureBlobServices? = AzureBlobServices()) {
        self.model = model
        self.noticiaService = noticiaService!
        self.blobService = blobService!
        
        super.init(nibName: nil, bundle: nil)
        
        //Añadimos una entrada en la tabla de visitas
        self.noticiaService.addVisita(noticia: model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        syncModelToView()
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
        noticiaService.getValoracion(noticia: model){ (valoracion, error) in
            if valoracion > 0 {
                DispatchQueue.main.async {
                    self.valorView.selectedSegmentIndex = valoracion  - 1
                }
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
