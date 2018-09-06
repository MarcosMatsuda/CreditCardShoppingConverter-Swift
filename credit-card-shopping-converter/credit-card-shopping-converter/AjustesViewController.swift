//
//  AjustesViewController.swift
//  credit-card-shopping-converter
//
//  Created by Marcos Matsuda on 06/09/2018.
//  Copyright © 2018 Marcos Matsuda. All rights reserved.
//

import UIKit

class AjustesViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //???
    @IBAction func addEstado(_ sender: Any) {
        showAlert(state: nil)
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
            let tributeValue = alert.textFields![1].text!
            
            let state = state ?? States(context: self.context)
            state.name = stateName
            state.tribute = Double(tributeValue) ?? 0.0
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }))
        self.present(alert, animated: true)
        
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
