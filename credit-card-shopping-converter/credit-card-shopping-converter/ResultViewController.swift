//
//  ResultViewController.swift
//  credit-card-shopping-converter
//
//  Created by Marcos Matsuda on 23/09/2018.
//  Copyright © 2018 Marcos Matsuda. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController: UIViewController {
    
    @IBOutlet weak var lbTotalReal: UILabel!
    @IBOutlet weak var lbTotalDollar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        calculate()
    }
    
    public func calculate(){
        
        var products  = [Product]()
        var sumReal: Double = 0.0
        var sumDollar: Double = 0.0
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            
            products = try managedContext.fetch(fetchRequest) as! [Product]
            for product in products {
                
//                print(product.name!)
//                print(product.credit_card)
//                print(product.price)
//                print(product.state?.name)
//                print(product.state?.tribute)
                
                sumDollar += product.price
                sumReal += product.price
            }
            
            lbTotalDollar.text = String(format:"%.2f", sumDollar)
            lbTotalReal.text = String(format:"%.2f", sumReal)
            
        } catch {
            print("Fetching Failed")
        }

        // Then you can use your properties.
        
        
    }

}
