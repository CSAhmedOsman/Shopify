//
//  OrderTableViewCell.swift
//  SwiftCart
//
//  Created by Elham on 20/06/2024.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var ProductNum: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 30
        self.contentView.layer.borderWidth = 1.0
        let secColor = UIColor(.black)
        self.contentView.layer.borderColor = secColor.cgColor
    }
}



