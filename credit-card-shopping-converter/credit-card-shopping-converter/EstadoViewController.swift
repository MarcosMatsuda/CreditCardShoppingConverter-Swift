//
//  EstadoViewController.swift
//  credit-card-shopping-converter
//
//  Created by Marcos Matsuda on 28/08/2018.
//  Copyright © 2018 Marcos Matsuda. All rights reserved.
//

import UIKit

class EstadoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEstado(_ sender: Any) {
//        showAlert(category: nil)
        
    }
    
    func showAlert(category: Category?){
        let title = "Adicionar estado"
        let alert = UIAlertController(title: title, message: "Preencha a categoria abaixo", preferredStyle: .alert)
        
        //        let okAction = UIAlertAction(title: "Adicionar", style: .default) { (action) in
        //            let estadoName = alert.textFields![0].text!
        //            let cat = category ?? Category(context: self.context)
        //            cat.name = estadoName
        //            try! self.context.save()
        //            self.loadCategories()
        //        }
        //
        //        alert.addTextField { (textField) in
        //            textField.placeholder = "Nome da estado"
        //            textField.text = category?.name
        //        }
        
        //        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        //        alert.addAction(okAction)
        //        alert.addAction(cancelAction)
        //
        present(alert, animated: true, completion: nil)
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
