//
//  ProductTableViewCell.swift
//  credit-card-shopping-converter
//
//  Created by Marcos Matsuda on 03/09/2018.
//  Copyright © 2018 Marcos Matsuda. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with product: Product){
        lbName.text = product.name ?? ""
    }
}
