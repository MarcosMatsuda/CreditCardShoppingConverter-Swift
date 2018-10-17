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
    var fetchedStatesResultsController: NSFetchedResultsController<States>!
    var fetchedRatesResultsController: NSFetchedResultsController<Rates>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dollarQuotation: UITextField!
    @IBOutlet weak var taxOnFinancialOrder: UITextField!
    
    var rate: Rates!
    var _dollarQuotation:Double = 0.0
    var _taxOnFinancialOrder: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadStates()
        
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        
        //ONLY READ
        dollarQuotation.isUserInteractionEnabled = false
        taxOnFinancialOrder.isUserInteractionEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        let userDefaults = UserDefaults.standard
        
        let iof_reference = userDefaults.string(forKey: "iof_reference")
        if let iof = iof_reference{
            taxOnFinancialOrder.text = iof
        }
        
        let cotacao_dollar_reference = userDefaults.string(forKey: "cotacao_dollar_reference")
        if let dollar = cotacao_dollar_reference{
            dollarQuotation.text = dollar
        }
    }
    
    func loadStates(){
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedStatesResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedStatesResultsController.delegate = self
        
        do{
            try fetchedStatesResultsController.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requireAlert(mensagem: String){
        
        let alert = UIAlertController(title: mensagem, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
    }
    
  
    
    @IBAction func addEstado(_ sender: Any) {
        showAlert(state: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedStatesResultsController.fetchedObjects?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_states", for: indexPath) 
        guard let state = fetchedStatesResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tribute)%"
        return cell
  
    }
    
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
            
            let rate = Rates(context: self.context)
            rate.dollarQuotation = self._dollarQuotation
            rate.taxOnFinancialOrder = self._taxOnFinancialOrder
            
            let state = state ?? States(context: self.context)
            if let stateField = alert.textFields?.first, !(stateField.text?.isEmpty)!{
                state.name = stateField.text
            }else{
                self.requireAlert(mensagem: "Nome do estado é obrigatório")
                self.context.rollback()
                return
            }
            
            if let taxField = alert.textFields?.last, !(taxField.text?.isEmpty)!{
                let tributeValue = alert.textFields?.last?.text
                state.tribute = tributeValue?.toDouble() ?? 0.0
            }else{
                self.requireAlert(mensagem: "Imposto é obrigatório")
                self.context.rollback()
                return
            }
            
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
            
        }))
        present(alert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let product = fetchedStatesResultsController.fetchedObjects?[indexPath.row] else {return}
            context.delete(product)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = fetchedStatesResultsController.object(at: indexPath)
        showAlert(state: state)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
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
