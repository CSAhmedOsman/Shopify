//
//  AddressesViewController.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit

class AddressesViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    var viewModel : AddressesViewModel?

    @IBOutlet weak var AddressesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressesViewModel()
        AddressesTable.dataSource = self
        AddressesTable.delegate = self
        viewModel?.bindAddresses = { [weak self] in
            self?.AddressesTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getAddressesList()
    }
    

    @IBAction func addNewAddress(_ sender: Any) {
        coordinator?.goToAddAddress()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    

    
}

extension AddressesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getAddresesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          guard let selectedAddress = viewModel?.getAddressByIndex(index: indexPath.row) else {
              return
          }
        coordinator?.goToAddressDetails(address: selectedAddress)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        let address = viewModel?.getAddressByIndex(index: indexPath.row)
        cell.textLabel?.text = "\(address?.address1 ?? "") - \(address?.city ?? "")"
        cell.imageView?.image = UIImage(named: "Location Icon")?.resized(to: CGSize(width: 32, height: 32))
        if let isDefault = viewModel?.getAddressByIndex(index: indexPath.row).isDefault, isDefault {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }


    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               if  (viewModel?.addressesList?[indexPath.row].isDefault == true) {
                   Utils.showAlert(title: "Delete", message: "You cannot delete the default address.", preferredStyle: .alert, from: self)
               } else {
                   let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
                   let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                       self?.viewModel?.deleteAddress(index: indexPath.row)
                   }
                   Utils.showAlert(title: "Delete", message:  "Are you sure you want to delete this Address?", preferredStyle: .alert, from: self, actions: [deleteAction, cancelAction])
               }
           }
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60.0 // Set the desired cell height here
       }
    }
    
    
    

