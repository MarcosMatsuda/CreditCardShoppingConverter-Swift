//
//  AjustesViewController.swift
//  credit-card-shopping-converter
//
//  Created by Marcos Matsuda on 06/09/2018.
//  Copyright © 2018 Marcos Matsuda. All rights reserved.
//

import UIKit
import CoreData

class AjustesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var labelEmptyTable = UILabel()
    var fetchedResultsController: NSFetchedResultsController<States>!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadStates()
    }
    
    func loadStates(){
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //???
    @IBAction func addEstado(_ sender: Any) {
        showAlert(state: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        print("marcos")
//        tableView.backgroundView = count == 0 ? labelEmptyTable : nil
        return count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_states", for: indexPath) 
        guard let state = fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "% \(state.tribute)"
        return cell
  
    }
    
    
    func showAlert(state: States?){
        let alert = UIAlertController(title: "Adicionar estado", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Nome do estado"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Imposto"
        })
        
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { action in
            
            let stateName = alert.textFields![0].text!
//            let tributeValue = alert.textFields![1].text!
//
            let state = state ?? States(context: self.context)
            state.name = stateName
//            state.tribute = Double(tributeValue) ?? 0.0
            do {
                try self.context.save()
                //self.loadSates()
                //nao esta atualizando a lista
            } catch {
                print(error.localizedDescription)
            }
            
        }))
        self.present(alert, animated: true)
        
    }
}

extension AjustesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            tableView.reloadData()
        }
    }
   
}
