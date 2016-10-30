//
//  NoticiasLectorTableVC.swift
//  Scoops
//
//  Created by Akixe on 30/10/16.
//  Copyright © 2016 AOA. All rights reserved.
//

import UIKit

class NoticiasLectorTableVC: UITableViewController {

    var model: Noticias? = []
    let noticiaService : NoticiaService
    var filteredNoticias = Noticias()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    init(noticiaService: NoticiaService = NoticiaService()) {
        self.noticiaService = noticiaService
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    
    override func viewWillAppear(_ animated: Bool) {
        readAllNoticias()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchContextActive() {
            return filteredNoticias.count
        }
        if let m = model {
            return m.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        let noticia : Noticia?
        if searchContextActive() {
            noticia = filteredNoticias[indexPath.row]
        } else {
            noticia = model?[indexPath.row]
        }
        cell.textLabel?.text = noticia?.titulo
        cell.detailTextLabel?.text = noticia?.autor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noticia : Noticia?
        
        if searchContextActive() {
            noticia = filteredNoticias[indexPath.row]
        } else {
            noticia = model?[indexPath.row]
        }
        if let _noticia = noticia  {
            openNoticiaVC(withModel: _noticia)
        }
        searchController.isActive = false
    }
    
    func searchContextActive() -> Bool {
        return searchController.isActive
    }
    
    func readAllNoticias(){
        noticiaService.getNoticiasLector { (noticias, error) in
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
        let noticiaVC = NoticiaLectorVC(model: model, noticiaService: self.noticiaService)
        self.navigationController?.pushViewController(noticiaVC, animated: true)
    }
    
    func filterNoticiasFor(searchText: String, scope: String = "Todo") {
        filteredNoticias = (model?.filter { noticia in
            return (noticia.titulo?.lowercased().contains(searchText.lowercased()))!
            
        })!
        
        tableView.reloadData()
    }

}

extension NoticiasLectorTableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterNoticiasFor(searchText: searchController.searchBar.text!, scope: "Todo")
    }
}
