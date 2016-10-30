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
        
        let noticiaService = NoticiaService()
        if let _ = noticiaService.client.currentUser {
            loadNoticiasEditor(noticiaService: noticiaService)
        } else {
            loginConFacebook(noticiaService: noticiaService, editor: true)
        }
        
    }
    
    @IBAction func loginLector(_ sender: AnyObject) {
        
        let noticiaService = NoticiaService()
        if let _ = noticiaService.client.currentUser {
            loadNoticiasLector(noticiaService: noticiaService)
        } else {
            loginConFacebook(noticiaService: noticiaService, editor: false)
        }
        
    }
    
    func loadNoticiasEditor(noticiaService: NoticiaService) {
        let noticiasEditorTableVC = NoticiasEditorTableVC(editor: "aa",
                                                          noticiaService: noticiaService)
        loadVC(viewController: noticiasEditorTableVC)
    }
    
    func loadNoticiasLector(noticiaService: NoticiaService) {
        let noticiasEditorTableVC = NoticiasLectorTableVC(noticiaService: noticiaService)
        loadVC(viewController: noticiasEditorTableVC)
    }
    
    func loadVC(viewController: UIViewController) {
        
        let editorNavVC = UINavigationController(rootViewController: viewController)
        let appDelegate = UIApplication.shared.delegate;
        appDelegate?.window??.rootViewController = editorNavVC
    }
    
    func loginConFacebook(noticiaService: NoticiaService, editor: Bool) {
        noticiaService.client.login(withProvider: "facebook", parameters: nil, controller: self, animated: true) { (user, error) in
            if let _ = error {
                print(error)
                return
            }
            
            if let _ = user {
                print(user)
                if editor {
                    self.loadNoticiasEditor(noticiaService:noticiaService)
                } else {
                    self.loadNoticiasLector(noticiaService:noticiaService)
                }
                
            }
            
        }
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
