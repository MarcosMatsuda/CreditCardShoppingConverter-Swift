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
    
    //ok
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
    
    //ok
    @IBAction func addEstado(_ sender: Any) {
        showAlert(state: nil)
    }
    
    //ok
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        return count
    }
    
    
    //ok
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_states", for: indexPath) 
        guard let state = fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tribute)%"
        return cell
  
    }
    
    //ok
    func showAlert(state: States?){
        
        let title = state == nil ? "Adicionar" : "Editar"
        
        let alert = UIAlertController(title: title + " estado", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Imposto"
            if let tribute = state?.tribute {
                textField.text = String(format:"%f", tribute)
            }
        })

        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            let state = state ?? States(context: self.context)
            state.name = alert.textFields?.first?.text
            
            let tributeValue = alert.textFields?.last?.text
            state.tribute = tributeValue?.toDouble() ?? 0.0
            
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
            
        }))
        present(alert, animated: true)
        
    }
    
    //ok
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //ok
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let product = fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
            context.delete(product)
        }
    }
    
    //ok
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = fetchedResultsController.object(at: indexPath)
        showAlert(state: state)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//ok
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

//ok
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
