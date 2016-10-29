//
//  LoginVC.swift
//  Scoops
//
//  Created by Akixe on 28/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var nombreEditorView: UITextField!
    @IBAction func loginEditor(_ sender: AnyObject) {
        
        //if !(nombreEditorView.text?.isEmpty)! {
        
            let noticiasEditorTableVC = NoticiasEditorTableVC(editor: "aa",
                                                              azClient: AzureServices.mobileAppClient)
            let editorNavVC = UINavigationController(rootViewController: noticiasEditorTableVC)
        
        
        
        let appDelegate = UIApplication.shared.delegate;
        appDelegate?.window??.rootViewController = editorNavVC
        //}
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
