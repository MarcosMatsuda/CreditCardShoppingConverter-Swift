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
    
    let settingBundleHelper = SettingBundleHelper()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        calculate()
    }
    
    public func calculate(){
        
        var products  = [Product]()
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            
            products = try managedContext.fetch(fetchRequest) as! [Product]
            calculateDollar( products: products )
            calculateReal( products: products )
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func calculateReal(products: [Product]){
        
        var sumReal: Double = 0.0
        let iofPrice = settingBundleHelper.IOFPrice()
        let dollarCotation = settingBundleHelper.getDollarPrice()
        
        for product in products {
            
            let productTribute = product.state?.tribute as! Double
            let taxState = (productTribute != 0.0 ? productTribute/100 : 0)+1
            let iof = ( (iofPrice != 0.0 ? iofPrice/100 : 0) + 1 )
            
            if product.credit_card {
                
                sumReal += product.price * iof * taxState
                
            }else{
                
                sumReal += product.price
            }
        }
        
        lbTotalReal.text = String(format:"%.2f", dollarCotation * sumReal)
        
    }
    
    func calculateDollar(products: [Product]){
        
        let prices = products.map({ (products: Product) -> Double in
            products.price
        })
        
        let total = prices.reduce(0, +)
        
        lbTotalDollar.text = String(format:"%.2f", total)
    }

}
