//
//  SettingsBundleHelper.swift
//  credit-card-shopping-converter
//
//  Created by Marcos Matsuda on 17/10/2018.
//  Copyright © 2018 Marcos Matsuda. All rights reserved.
//

import Foundation

class SettingBundleHelper {
    
    let appDefaults = [String:AnyObject]()
    
    init() {
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func getDollarPrice()->Double{
        
        let userDefaults = UserDefaults.standard

        let cotacao_dollar_reference = userDefaults.string(forKey: "cotacao_dollar_reference")
        if let dollar = cotacao_dollar_reference{
            return Double(dollar)!
        }
        
        return 1.0
    }
    
    func IOFPrice()->Double {
        
        let userDefaults = UserDefaults.standard
        let iof_reference = userDefaults.string(forKey: "iof_reference")
        if let iof = iof_reference{
            return Double(iof)!
        }
        
        return 1.0
    }
    
}
