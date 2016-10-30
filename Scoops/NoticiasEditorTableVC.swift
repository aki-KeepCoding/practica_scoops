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
    var filteredNoticias = Noticias()
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
        
        searchController.searchBar.scopeButtonTitles = ["Todo",
                                                        Estado.privado.rawValue,
                                                        Estado.publicable.rawValue,
                                                        Estado.publicado.rawValue]
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
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
    
    
    func filterNoticiasFor(searchText: String, scope: String = "Todo") {
        filteredNoticias = (model?.filter { noticia in
            let estadoMatch = scope == "Todo" || (noticia.estado == Estado(rawValue: scope))
            
            if searchText == "" {
                return estadoMatch
            } else {
                return estadoMatch && (noticia.titulo?.lowercased().contains(searchText.lowercased()))!
            }
            
            })!
        
        tableView.reloadData()
    }

}


extension NoticiasEditorTableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterNoticiasFor(searchText: searchController.searchBar.text!, scope: scope)
    }
}


extension NoticiasEditorTableVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterNoticiasFor(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
