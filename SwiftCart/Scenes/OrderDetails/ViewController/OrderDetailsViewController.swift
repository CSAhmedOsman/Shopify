//
//  OrderDetailsViewController.swift
//  SwiftCart
//
//  Created by Elham on 20/06/2024.
//

import UIKit
import SDWebImage

class OrderDetailsViewController: UIViewController {

   
        weak var coordinator: AppCoordinator?//SettingsCoordinator?
        var orderDetails: Order?

        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var orderNum: UILabel!
        @IBOutlet weak var ProductNum: UILabel!
        @IBOutlet weak var address: UILabel!
        @IBOutlet weak var phone: UILabel!
        @IBOutlet weak var date: UILabel!
        @IBOutlet weak var price: UILabel!
    
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
           
            tableView.dataSource = self
            tableView.delegate = self
            ProductNum.text = "\(orderDetails!.productNumber!)"
            orderNum.text = orderDetails?.orderNumber
            address.text = "\(orderDetails!.address!.address1!) \(orderDetails!.address!.city!)"
            date.text = Utils.extractDate(from:  orderDetails?.date ?? "2024-05-27T08:25:00-04:00")
            //TODO: formatAsCurrency
            price.text = "\(orderDetails!.totalPrice)  \(orderDetails!.currency.rawValue)"
            
            //phone.text = orderDetails.phone
            
            self.tableView.reloadData()
            }
    @IBAction func goToFav(_ sender: Any) {
        coordinator?.goToFav()
    }
        
            
        @IBAction func backBtn(_ sender: Any) {
            coordinator?.finish()
        }
        
    }

    extension OrderDetailsViewController : UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return orderDetails?.items.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetails", for: indexPath) as? OrderDetailsTableViewCell
            let order = orderDetails?.items[indexPath.section]
            cell?.productTitle.text = order?.title
            //TODO: formatAsCurrency
            cell?.price.text = "\(order!.price) \(orderDetails!.currency.rawValue)"
            cell?.quantity.text = "\(order!.quantity)"
            if let imageUrl = URL(string: order?.image ?? "9") {
                cell?.img.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "9"))
            }
            

            return cell!
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0.1 // Adjust the height for the header between sections
           }
           
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            var label = UILabel()
            label.sizeThatFits(CGSize(width: 100.0, height: 8.0))
            return label
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               return 100
           }
        }
        
        
