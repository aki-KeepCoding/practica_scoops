//
//  NoticiaAnalyticsVC.swift
//  Scoops
//
//  Created by Akixe on 30/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import UIKit

class NoticiaAnalyticsVC: UIViewController {

    let noticiaService : NoticiaService
    let model : Noticia
    
    @IBOutlet weak var visitasView: UITextField!
    @IBOutlet weak var meGustaView: UITextField!
    @IBOutlet weak var meEncantaView: UITextField!
    @IBOutlet weak var noMeGustaView: UITextField!
    
    init(model: Noticia, noticiaService : NoticiaService = NoticiaService()) {
        self.model = model
        self.noticiaService = noticiaService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noticiaService.getStats(noticia: model){ (result, error) in
            DispatchQueue.main.async {
                if let res = result {
                    if let visitas = res["visitas"] as? Int {
                        self.visitasView.text = String(visitas)
                    }
                    
                    if let meGusta = res["meGusta"] as? Int {
                        self.meGustaView.text = String(meGusta)
                    }
                    
                    if let meEncanta = res["meEncanta"] as? Int {
                        self.meEncantaView.text = String(meEncanta)
                    }
                    
                    if let noMeGusta = res["noMeGusta"] as? Int {
                        self.noMeGustaView.text = String(noMeGusta)
                    }
                }
                
            }
        }
        // Do any additional setup after loading the view.
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
