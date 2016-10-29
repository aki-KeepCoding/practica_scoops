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
    let azClient : MSClient
    
    
    init(editor: String, azClient: MSClient = AzureServices.mobileAppClient) {
        //self.model = DummyData.generateDummyNoticias()
        self.azClient = azClient
        
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                                                 target: self,
                                                                 action: #selector(self.addNoticia))
        readAllNoticias()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
            openNoticiaVC(withModel: noticia, andAzClient: azClient)
        }
    }
    
    func addNoticia(){
        openNoticiaVC(withModel: Noticia(withAutor: "Akixe"), andAzClient: azClient)
    }
    
    func readAllNoticias(){
        NoticiaService.getAll { (noticias, error) in
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
    
    func openNoticiaVC(withModel model: Noticia, andAzClient azClient: MSClient ) {
        let noticiaVC = NoticiaVC(model: model, azClient: azClient)
        self.navigationController?.pushViewController(noticiaVC, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
