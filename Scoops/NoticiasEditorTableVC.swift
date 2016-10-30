//
//  NoticiasAdministradorTableVC.swift
//  Scoops
//
//  Created by Akixe on 24/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import UIKit

class NoticiasEditorTableVC: UITableViewController {

    var model: Noticias? = []
    let noticiaService : NoticiaService
    
    
    init(editor: String, noticiaService: NoticiaService = NoticiaService()) {
        self.noticiaService = noticiaService
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                                                 target: self,
                                                                 action: #selector(self.addNoticia))
    }

    override func viewWillAppear(_ animated: Bool) {
        readAllNoticias()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let m = model {
            return m.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = model?[indexPath.row].titulo
        cell.detailTextLabel?.text = model?[indexPath.row].autor
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let noticia = model?[indexPath.row] {
            openNoticiaVC(withModel: noticia)
        }
    }
    
    func addNoticia(){
        openNoticiaVC(withModel: Noticia(withAutor: "Akixe"))
    }
    
    func readAllNoticias(){
        noticiaService.getAll { (noticias, error) in
            if let _ = error {
                print(error)
                return
            }
            if !((self.model?.isEmpty)!) {
                self.model?.removeAll()
            }
            self.model?.append(contentsOf: noticias)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func openNoticiaVC(withModel model: Noticia) {
        let noticiaVC = NoticiaVC(model: model, noticiaService: self.noticiaService)
        self.navigationController?.pushViewController(noticiaVC, animated: true)
    }

}
