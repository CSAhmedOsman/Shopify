//
//  OrderViewController.swift
//  SwiftCart
//
//  Created by Elham on 20/06/2024.
//

import UIKit

class OrderViewController: UIViewController {

    weak var coordinator: AppCoordinator?//SettingsCoordinator?
    var viewModel : OrderViewModel?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrderViewModel()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel?.bindOrder = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getOrdersList()
    }
        
    @IBAction func goToFav(_ sender: Any) {
        coordinator?.goToFav()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    

    
}

extension OrderViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.getOrdersCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          guard let selectedOrder = viewModel?.getOrderByIndex(index: indexPath.row) else {
              return
          }
        coordinator?.goToOrdersDerails(orderDetails: selectedOrder)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderTableViewCell
        let order = viewModel?.getOrderByIndex(index: indexPath.section)
        cell?.ProductNum.text = "\(order!.productNumber!)"
        cell?.orderNum.text = order?.orderNumber
        cell?.address.text = "\(order!.address!.address1!) \(order!.address!.city!)"
        cell?.date.text =  Utils.extractDate(from:  order?.date ?? "2024-05-27T08:25:00-04:00")
        print(order?.date ?? "")
        //TODO: formatAsCurrency
        cell?.price.text = "\(order!.totalPrice)  \(order!.currency.rawValue)"
       // cell?.phone.text = order?.phone
        

        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1// Adjust the height for the header between sections
       }
       
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var label = UILabel()
        label.sizeThatFits(CGSize(width: 100.0, height: 8.0))
        return label
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 100
        // Set the desired cell height here
       }
    }
    
    
    


